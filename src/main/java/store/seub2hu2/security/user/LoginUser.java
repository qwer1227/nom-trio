package store.seub2hu2.security.user;

import lombok.*;
import store.seub2hu2.user.vo.User;

import java.io.Serial;
import java.io.Serializable;

@NoArgsConstructor
@Getter
@Setter
public class LoginUser {

	private int no;
	private String id;
	private String nickname;

	public 	LoginUser(User user){
		this.no = user.getNo();
        this.nickname = user.getNickname();
        this.id= user.getId(); // default no value for new user.
	}
}
