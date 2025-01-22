package store.seub2hu2.community.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import store.seub2hu2.community.dto.MarathonForm;
import store.seub2hu2.community.service.MarathonService;
import store.seub2hu2.community.vo.Crew;
import store.seub2hu2.community.vo.Marathon;
import store.seub2hu2.community.vo.MarathonOrgan;
import store.seub2hu2.util.ListDto;
import store.seub2hu2.util.RequestParamsDto;

import java.time.Duration;
import java.util.*;

@Controller
@RequestMapping("/community/marathon")
@RequiredArgsConstructor
public class MarathonController {

    private final RedisTemplate<String, String> redisTemplate;

    public final MarathonService marathonService;

    @GetMapping("/main")
    public String list(@ModelAttribute("dto") RequestParamsDto dto, Model model) {

        ListDto<Marathon> mDto = marathonService.getMarathons(dto);

        model.addAttribute("marathons", mDto.getData());
        model.addAttribute("paging", mDto.getPaging());
        model.addAttribute("now", new Date());

        return "community/marathon/main";
    }

    @Transactional
    @GetMapping("/hit")
    public String hit(@RequestParam("no") int marathonNo){
//        try{
//            String redisKey = "marathon:viewCount" + marathonNo;
//
//            // 남은 시간(초) 반환
//            System.out.println("TTL 설정 확인: " + redisTemplate.getExpire(redisKey));
//
//            // Redis에서 키가 존재하지 않으면 set
//            Boolean isFirstAccess = redisTemplate.opsForValue().setIfAbsent(redisKey, "30", Duration.ofMinutes(30));
//
//            if (Boolean.FALSE.equals(isFirstAccess)){
//                System.out.println("30분 내 조회수 업데이트 제한");
//                return "redirect:detail?no=" + marathonNo;
//            }
//
//            redisTemplate.opsForValue().set(redisKey, "30", Duration.ofMinutes(30));
//            marathonService.updateMarathonViewCnt(marathonNo);
//        } catch (Exception e){
//            e.printStackTrace();
//        }

        return "redirect:detail?no=" + marathonNo;

    }

    @GetMapping("/detail")
    public String detail(@RequestParam("no") int marathonNo, Model model) {

        Marathon marathon = marathonService.getMarathonDetail(marathonNo);
        model.addAttribute("marathon", marathon);

        List<MarathonOrgan> organs = marathonService.getOrgans(marathonNo);
        StringJoiner host = new StringJoiner(", ");
        StringJoiner organizer = new StringJoiner(", ");
        for (MarathonOrgan organ : organs) {
            if ("주최".equals(organ.getOrganRole())){
                host.add(organ.getOrganName());
            } else if ("주관".equals(organ.getOrganRole())){
                organizer.add(organ.getOrganName());
            }
            model.addAttribute("host", host.toString());
            model.addAttribute("organizer", organizer.toString());
        }

        // url 클릭 시, 해당 url 홈페이지로 이동
        String url = marathon.getUrl();
        if (!url.startsWith("http")) {
            url = "https://www." + url;
        }
        model.addAttribute("marathonUrl", url);
        model.addAttribute("now", new Date());

        return "community/marathon/detail";
    }

    @GetMapping("/form")
    public String form() {
        return "community/marathon/form";
    }

    @PostMapping("/register")
    @ResponseBody
    public Marathon register(MarathonForm form) {
        Marathon marathon = marathonService.addNewMarathon(form);
        return marathon;
    }

    @GetMapping("/modify")
    public String modifyForm(@RequestParam("no") int marathonNo, Model model) {
        Marathon marathon = marathonService.getMarathonDetail(marathonNo);
        model.addAttribute("marathon", marathon);

        List<MarathonOrgan> organs = marathonService.getOrgans(marathonNo);
        StringJoiner host = new StringJoiner(", ");
        StringJoiner organizer = new StringJoiner(", ");
        for (MarathonOrgan organ : organs) {
            if ("주최".equals(organ.getOrganRole())){
                host.add(organ.getOrganName());
            } else if ("주관".equals(organ.getOrganRole())){
                organizer.add(organ.getOrganName());
            }
            model.addAttribute("host", host.toString());
            model.addAttribute("organizer", organizer.toString());
        }

        return "community/marathon/modify";
    }

    @PostMapping("/modify")
    @ResponseBody
    @PreAuthorize("isAuthenticated()")
    public Marathon update(MarathonForm form) {
        Marathon marathon = marathonService.updateMarathon(form);
        return marathon;
    }

    @GetMapping("/delete")
    public String delete(@RequestParam("no") int marathonNo) {
        MarathonForm form = new MarathonForm();
        form.setNo(marathonNo);
        marathonService.deleteMarathon(marathonNo);

        return "redirect:main";
    }

}
