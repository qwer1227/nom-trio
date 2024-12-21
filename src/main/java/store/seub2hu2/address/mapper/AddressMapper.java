package store.seub2hu2.address.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import store.seub2hu2.user.vo.Addr;

import java.util.List;

@Mapper
public interface AddressMapper {

    List<Addr> selectAddressesByUserNo(int userNo);

    void deleteAddressByNo(@Param("addrNo") int addrNo);

    void updateAddress(@Param("addr")  Addr addr);
}
