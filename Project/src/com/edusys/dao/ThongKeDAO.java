package com.edusys.dao;

import com.edusys.utils.XJdbc;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ThongKeDAO {
    private List<Object[]> getListOfArray(String sql, String[] valueRS, Object...args){
        try {
            List<Object[]> list = new ArrayList<>();
            ResultSet rs = XJdbc.query(sql, args);
            while(rs.next()){
                Object[] vals = new Object[valueRS.length];
                for(int i=0; i<valueRS.length; i++){
                    vals[i] = rs.getObject(valueRS[i]);
                    System.out.println(valueRS[i] + ": " + rs.getObject(valueRS[i]));
                }
                list.add(vals);
            }
            rs.getStatement().getConnection().close();
            return list;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public List<Object[]> getBangDiem(Integer makh){
        String sql = "{CALL sp_BangDiem (?)}";
        String[] valueRS = {"MaNH", "HoTen", "Diem"};
        return this.getListOfArray(sql, valueRS, makh);
    }
    
    public List<Object[]> getLuongNguoiHoc(){
        String sql = "{CALL sp_ThongKeNguoiHoc}";
        String[] valueRS = {"Nam", "SoLuong", "DauTien", "CuoiCung"};
        return this.getListOfArray(sql, valueRS);
    }
    
    public List<Object[]> getDiemChuyenDe(){
        String sql = "{CALL sp_ThongKeDiemChuyenDe}";
        String[] valueRS = {"ChuyenDe", "SoHV", "ThapNhat", "CaoNhat", "TrungBinh"};
        return this.getListOfArray(sql, valueRS);
    }
    
    public List<Object[]> getDoanhThu(int nam){
        String sql = "{CALL sp_ThongKeDoanhThu (?)}";
        String[] valueRS = {"ChuyenDe", "SoKH", "SoHV",  "DoanhThu", "ThapNhat", "CaoNhat", "TrungBinh"};
        return this.getListOfArray(sql, valueRS, nam);
    }
}

