package store.seub2hu2.address.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import store.seub2hu2.address.mapper.AddressMapper;
import store.seub2hu2.user.vo.Addr;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AddressService {
    private final AddressMapper addressMapper;

    // 주소 목록 조회
    public List<Addr> getAddressListByUserNo(int userNo) {
        return addressMapper.selectAddressesByUserNo(userNo);
    }


    // 주소 삭제
    public void deleteAddress(int addrNo) {
        addressMapper.deleteAddressByNo(addrNo);
    }

    // 주소 수정
    public void updateAddress(Addr addr) {
        addressMapper.updateAddress(addr);
    }
}

