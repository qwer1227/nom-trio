package store.seub2hu2.community.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Service;
import store.seub2hu2.community.dto.FunctionCheckDto;
import store.seub2hu2.community.dto.ReportForm;
import store.seub2hu2.community.mapper.ReportMapper;
import store.seub2hu2.community.vo.Report;
import store.seub2hu2.community.enums.ReportReason;
import store.seub2hu2.security.user.LoginUser;
import store.seub2hu2.user.vo.User;

@Service
public class ReportService {

    @Autowired
    private ReportMapper reportMapper;
    @Autowired
    private BoardService boardService;
    @Autowired
    private CrewService crewService;
    @Autowired
    private ReplyService replyService;

    public Report registerReport(ReportForm form
            , @AuthenticationPrincipal LoginUser loginUser) {

        Report report = new Report();
        report.setType(form.getType());
        report.setReason(form.getReason());
        report.setType(form.getType());
        report.setNo(form.getNo());

        if (form.getReason() != 6) {
            report.setDetail(ReportReason.getDescriptionByReasonNo(form.getReason()));
        } else {
            report.setDetail(form.getDetail());
        }

        User user = new User();
        user.setNo(loginUser.getNo());
        user.setNickname(loginUser.getNickname());
        report.setUser(user);

        reportMapper.insertReport(report);

        return report;
    }

    public boolean isReported(String type
            , int no
            , @AuthenticationPrincipal LoginUser loginUser) {

        FunctionCheckDto dto = new FunctionCheckDto();
        dto.setType(type);
        dto.setTypeNo(no);
        dto.setUserNo(loginUser.getNo());

        return reportMapper.isAlreadyReported(dto);
    }

    public void updateReport(String type, int no){
        FunctionCheckDto dto = new FunctionCheckDto();
        dto.setType(type);
        dto.setTypeNo(no);
        reportMapper.updateReportStatus(dto);

        if (type.equals("board")){
            boardService.updateBoardReport(no);
        } else if (type.equals("crew")){
            crewService.updateCrewReport(no);
        } else if (type.equals("boardReply") || type.equals("crewReply")){
            replyService.updateReplyReport(no);
        }
    }
}
