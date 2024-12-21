package store.seub2hu2.community.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Service;
import store.seub2hu2.community.dto.ReportForm;
import store.seub2hu2.community.mapper.ReportMapper;
import store.seub2hu2.community.vo.Report;
import store.seub2hu2.security.user.LoginUser;
import store.seub2hu2.user.vo.User;

@Service
public class ReportService {

    @Autowired
    private ReportMapper reportMapper;

    public Report registerReport(ReportForm form
            , @AuthenticationPrincipal LoginUser loginUser) {

        Report report = new Report();
        report.setType(form.getType());
        report.setReason(form.getReason());
        report.setType(form.getType());
        report.setNo(form.getNo());

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
        return reportMapper.isAlreadyReported(type, no, loginUser.getNo());
    }
}
