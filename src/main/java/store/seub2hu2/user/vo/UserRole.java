package store.seub2hu2.user.vo;

import org.apache.ibatis.type.Alias;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@NoArgsConstructor
@Getter
@Setter
@Alias("UserRole")
public class UserRole {

	private int userNo; // 사용자 번호
	private Role role;  // Role 객체를 포함하여 역할 정보 관리

	// 사용자 번호와 역할 객체를 전달받는 생성자
	public UserRole(int userNo, Role role) {
		this.userNo = userNo;
		this.role = role;
	}
}
