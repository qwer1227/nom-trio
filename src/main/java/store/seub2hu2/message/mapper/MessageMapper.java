package store.seub2hu2.message.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import store.seub2hu2.message.dto.MessageReceived;
import store.seub2hu2.message.vo.Message;
import store.seub2hu2.message.vo.MessageFile;

import java.util.List;
import java.util.Map;

@Mapper
public interface MessageMapper {

    // 메시지 삽입
    void insertMessage(@Param("message") Message message);

    // 메시지 수신자 삽입
    void insertMessageReceiver(@Param("messageNo") int messageNo, @Param("userNo") int userNo);

    // 조건에 맞는 메시지 수 조회
    int getMessageTotalRows(@Param("condition") Map<String, Object> condition);
    int getMessageRcvTotalRows(@Param("condition") Map<String, Object> condition);

    // 조건에 맞는 메시지 목록 조회
    List<MessageReceived> getMessages(@Param("condition") Map<String, Object> condition);

    // 받은 메시지 목록 조회
    List<MessageReceived> getReceivedMessages(@Param("condition") Map<String, Object> condition);

    // 보낸 메시지 목록 조회
    List<MessageReceived> getSentMessages(@Param("condition") Map<String, Object> condition);

    Message getMessageDetailByNo(@Param("messageNo") int messageNo);

    // 단일 메시지 삭제
    void deleteMessage(@Param("messageNo") int messageNo);

    // 단일 받은 메세지 읽음 처리
    void updateReadMarkMessageRcv(@Param("messageNo") int messageNo, @Param("userNo") int userNo);
    // 메세지 읽음 처리
    void updateReadMarkMessage(@Param("messageNo") int messageNo);
    // 단일 받은 메세지 삭제
    void deleteMessageRcv(@Param("messageNo") int messageNos, @Param("userNo") int userNo);


    void insertMessageFile(@Param("messageFile") MessageFile messageFile); // 파일 삽입

    boolean hasFiles(@Param("messageNo") int messageNo);
}
