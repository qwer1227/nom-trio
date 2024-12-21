package store.seub2hu2.handler;

import org.apache.ibatis.type.BaseTypeHandler;
import org.apache.ibatis.type.JdbcType;
import org.apache.ibatis.type.MappedJdbcTypes;
import org.apache.ibatis.type.MappedTypes;
import store.seub2hu2.mypage.enums.QnaStatus;

import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@MappedTypes(QnaStatus.class)  // 매핑할 Enum 클래스 지정
@MappedJdbcTypes(JdbcType.INTEGER)  // Enum과 매핑할 DB 타입 (int 값으로 저장)
public class QnaStatusTypeHandler extends BaseTypeHandler<QnaStatus> {

    @Override
    public void setNonNullParameter(PreparedStatement ps, int i, QnaStatus parameter, JdbcType jdbcType) throws SQLException {
        ps.setInt(i, parameter.getCode());  // Enum을 숫자 값으로 설정
    }

    @Override
    public QnaStatus getNullableResult(ResultSet rs, String columnName) throws SQLException {
        int code = rs.getInt(columnName);
        if (rs.wasNull()) {
            return null;  // null 처리
        }
        return QnaStatus.fromCode(code);  // 숫자 값을 Enum으로 변환
    }

    @Override
    public QnaStatus getNullableResult(ResultSet rs, int columnIndex) throws SQLException {
        int code = rs.getInt(columnIndex);
        if (rs.wasNull()) {
            return null;  // null 처리
        }
        return QnaStatus.fromCode(code);  // 숫자 값을 Enum으로 변환
    }

    @Override
    public QnaStatus getNullableResult(CallableStatement cs, int columnIndex) throws SQLException {
        int code = cs.getInt(columnIndex);
        if (cs.wasNull()) {
            return null;  // null 처리
        }
        return QnaStatus.fromCode(code);  // 숫자 값을 Enum으로 변환
    }
}
