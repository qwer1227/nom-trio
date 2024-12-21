package store.seub2hu2.user.service;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import lombok.RequiredArgsConstructor;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import store.seub2hu2.user.mapper.UserMapper;
import store.seub2hu2.user.vo.User;

import java.security.SecureRandom;
import java.util.Base64;
import java.util.NoSuchElementException;
import java.util.Optional;

@Service
@Transactional
@RequiredArgsConstructor
public class MailService {

    private final JavaMailSender mailSender;
    private final UserMapper userMapper;

    /**
     * 이메일로 인증 코드를 전송하고 반환
     */
    public String sendAuthCodeToEmail(String email) {
        // 이메일 검증
        if (email == null || !email.contains("@")) {
            throw new IllegalArgumentException("유효하지 않은 이메일 주소");
        }

        String authCode = generateAuthCode();

        // 메일 전송
        sendEmail(email, "이메일 인증 코드", "인증 코드: " + authCode);

        return authCode;
    }

    /**
     * 임시 비밀번호 생성 및 이메일 전송
     */
    public void updatePassword(String id, String email) {
        // 사용자 확인
        User user = userMapper.findUserByIdAndEmail(id, email);
        if (user == null) {
            throw new IllegalArgumentException("아이디와 이메일 정보가 일치하지 않음");
        }

        // 임시 비밀번호 생성
        String tempPassword = generateTempPassword();
        String encodedPassword = user.getPassword(); // 비밀번호는 안전하게 업데이트해야함.
        userMapper.updatePassword(id, encodedPassword);

        // 이메일로 임시 비밀번호 전송
        sendEmail(email, "임시 비밀번호 발급", "임시 비밀번호: " + tempPassword);
    }

    /**
     * 아이디 찾기 (이메일로 아이디 찾기)
     */
    public User findIdByEmail(String email) {
        User user = userMapper.getUserByEmail(email);
        if (user == null) {
            throw new NoSuchElementException("등록된 이메일이 없습니다.");
        }
        return user;
    }

    /**
     * 인증 코드 생성
     */
    private String generateAuthCode() {
        SecureRandom secureRandom = new SecureRandom();
        int code = secureRandom.nextInt(999999); // 6자리 숫자 생성
        return String.format("%06d", code); // 6자리 인증 코드
    }

    /**
     * 임시 비밀번호 생성
     */
    private String generateTempPassword() {
        SecureRandom secureRandom = new SecureRandom();
        byte[] randomBytes = new byte[8]; // 8바이트 길이의 임시 비밀번호를 생성
        secureRandom.nextBytes(randomBytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(randomBytes); // Base64 인코딩하여 반환
    }

    /**
     * 이메일 전송 메서드
     */
    private void sendEmail(String to, String subject, String content) {
        MimeMessage mimeMessage = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(mimeMessage);

        try {
            helper.setTo(to);
            helper.setSubject(subject);
            helper.setText(content);
            mailSender.send(mimeMessage);
        } catch (MessagingException e) {
            throw new RuntimeException("이메일 전송 실패", e);
        }
    }
}
