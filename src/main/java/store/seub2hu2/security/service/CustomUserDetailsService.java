package store.seub2hu2.security.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import store.seub2hu2.security.user.CustomUserDetails;
import store.seub2hu2.user.mapper.UserMapper;
import store.seub2hu2.user.vo.Role;
import store.seub2hu2.user.vo.User;

import java.util.List;

@Service
public class CustomUserDetailsService implements UserDetailsService{

	@Autowired
	private UserMapper userMapper;

	@Override
	public UserDetails loadUserByUsername(String id) throws UsernameNotFoundException {
		// 아이디로 사용자 정보를 조회한다.
		User user = userMapper.getUserById(id);

		// 조회된 사용자 정보가 없으면 UsernameNotFoundException예외를 발생시킨다.
		if (user == null) {
			throw new UsernameNotFoundException("["+id+"] 사용자가 없습니다.");
		}

		//
		List<Role> roles = userMapper.getRolesByUserNo(user.getNo());

		// UserDetails 구현객체를 생성해서 사용자정보(아이디, 비밀번호, 권한정보)를 담는다.
		CustomUserDetails customUserDetails = new CustomUserDetails(user, roles);

		return customUserDetails;
	}

}
