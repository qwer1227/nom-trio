package store.seub2hu2.user.vo;

import org.apache.ibatis.type.Alias;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
@Alias("Role")
public class Role {

	private int no;           // ROLE_NO
	private String name;      // ROLE_NAME
	private String description; // ROLE_DESC


}