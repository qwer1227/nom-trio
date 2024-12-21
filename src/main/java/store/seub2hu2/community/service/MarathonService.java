package store.seub2hu2.community.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;
import store.seub2hu2.community.dto.MarathonForm;
import store.seub2hu2.community.mapper.MarathonMapper;
import store.seub2hu2.community.mapper.UploadMapper;
import store.seub2hu2.community.vo.*;
import store.seub2hu2.security.user.LoginUser;
import store.seub2hu2.util.FileUtils;
import store.seub2hu2.util.ListDto;
import store.seub2hu2.util.Pagination;

import java.util.List;
import java.util.Map;

@Service
public class MarathonService {

    @Value("C:/files/marathon")
    private String saveFileDirectory;

    @Autowired
    private MarathonMapper marathonMapper;

    @Autowired
    private UploadMapper uploadMapper;

    public Marathon addNewMarathon(MarathonForm form) {
        Marathon marathon = new Marathon();
        marathon.setTitle(form.getTitle());
        marathon.setContent(form.getContent());
        marathon.setMarathonDate(form.getMarathonDate());
        marathon.setStartDate(form.getStartDate());
        marathon.setEndDate(form.getEndDate());
        marathon.setUrl(form.getUrl());
        marathon.setPlace(form.getPlace());
        marathon.setThumbnail(form.getThumbnail());

        marathonMapper.insertMarathon(marathon);

        if (StringUtils.hasText(form.getHost())) {
            // hostText = "우리은행, KBS, MBC"
            String hostText = form.getHost();
            // values = ["우리은행", " KBS", " MBC"]
            String[] values = hostText.split(",");
            for (String value : values) {
                MarathonOrgan organ = new MarathonOrgan();
                organ.setMarathonNo(marathon.getNo());
                organ.setOrganRole("host");
                organ.setOrganName(value.trim());
                marathonMapper.insertMarathonOrgan(organ);
            }
        }

        if (StringUtils.hasText(form.getOrganizer())) {
            String organizerText = form.getOrganizer();
            String[] values = organizerText.split(",");
            for (String value : values) {
                MarathonOrgan organ = new MarathonOrgan();
                organ.setMarathonNo(marathon.getNo());
                organ.setOrganRole("organizer");
                organ.setOrganName(value.trim());
                marathonMapper.insertMarathonOrgan(organ);
            }
        }

        return marathon;
    }

    public ListDto<Marathon> getMarathons(Map<String, Object> condition) {
        int totalRows = marathonMapper.getTotalMarathons(condition);

        int page = (Integer) condition.get("page");
        int rows = (Integer) condition.get("rows");
        Pagination pagination = new Pagination(page, totalRows, rows);

        condition.put("begin", pagination.getBegin());
        condition.put("end", pagination.getEnd());

        List<Marathon> marathons = marathonMapper.getMarathons(condition);
        ListDto<Marathon> dto = new ListDto<>(marathons, pagination);

        return dto;
    }

    public Marathon getMarathonDetail(int marathonNo) {
        Marathon marathon = marathonMapper.getMarathonDetailByNo(marathonNo);
        List<MarathonOrgan> organ = marathonMapper.getMarathonOrganDetailByNo(marathonNo);

        marathon.setOrgan(organ);

        return marathon;
    }

    public List<MarathonOrgan> getOrgans(int marathonNo) {
        List<MarathonOrgan> organs = marathonMapper.getMarathonOrganDetailByNo(marathonNo);

        return organs;
    }

    public void updateMarathonViewCnt(int marathonNo) {
        Marathon marathon = marathonMapper.getMarathonDetailByNo(marathonNo);
        marathon.setViewCnt(marathon.getViewCnt() + 1);
        marathonMapper.updateMarathonCnt(marathon);
    }

    public Marathon updateMarathon(MarathonForm form) {
        Marathon savedMarathon = marathonMapper.getMarathonDetailByNo(form.getNo());
        savedMarathon.setTitle(form.getTitle());
        savedMarathon.setContent(form.getContent());
        savedMarathon.setMarathonDate(form.getMarathonDate());
        savedMarathon.setStartDate(form.getStartDate());
        savedMarathon.setEndDate(form.getEndDate());
        savedMarathon.setUrl(form.getUrl());
        savedMarathon.setPlace(form.getPlace());
        savedMarathon.setThumbnail(form.getThumbnail());
        savedMarathon.setDeleted("N");

        marathonMapper.updateMarathon(savedMarathon);

        marathonMapper.deleteMarathonOrgan(form.getNo());

        if (StringUtils.hasText(form.getHost())) {
            String organizerText = form.getHost();
            String[] values = organizerText.split(",");
            for (String value : values) {
                MarathonOrgan organ = new MarathonOrgan();
                organ.setMarathonNo(form.getNo());
                organ.setOrganRole("host");
                organ.setOrganName(value.trim());
                marathonMapper.insertMarathonOrgan(organ);
            }
        }

        if (StringUtils.hasText(form.getOrganizer())) {
            String organizerText = form.getOrganizer();
            String[] values = organizerText.split(",");
            for (String value : values) {
                MarathonOrgan organ = new MarathonOrgan();
                organ.setMarathonNo(form.getNo());
                organ.setOrganRole("organizer");
                organ.setOrganName(value.trim());
                marathonMapper.insertMarathonOrgan(organ);
            }
        }
        return savedMarathon;
    }

    public void deleteMarathon(int marathonNo) {
        Marathon savedMarathon = marathonMapper.getMarathonDetailByNo(marathonNo);
        savedMarathon.setDeleted("Y");

        marathonMapper.updateMarathon(savedMarathon);
    }

    public ListDto<Marathon> getMarathonTop(Map<String, Object> condition) {
        List<Marathon> marathons = marathonMapper.getMarathonTopFive(condition);
        ListDto<Marathon> dto = new ListDto<>(marathons);

        return dto;
    }
}