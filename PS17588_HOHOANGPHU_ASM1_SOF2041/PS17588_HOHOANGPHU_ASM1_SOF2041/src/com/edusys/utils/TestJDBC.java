/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.edusys.utils;

import com.edusys.utils.XDate;
import com.edusys.utils.XJdbc;
import java.sql.*;

/**
 *
 * @author phuho
 */
public class TestJDBC {
//    public static void main(String[] args) throws Exception {
////        select("Select * from nguoihoc");
////        System.out.println("Chưa có j");
////        
////        insertDemo();
////        select("Select * from nguoihoc");
//        
////        XJdbc.update("UPDATE NguoiHoc SET HoTen=?, NgaySinh=?, GioiTinh=?, DienThoai=?, Email=?, GhiChu=?, MaNV=? WHERE MaNH=?",                
////                "Phú Hồ",
////                XDate.toDate("16/09/2002", "dd/mm/yyyy"),
////                true,
////                "0123456789",
////                "phu@gmail.com",
////                "Nghèo",
////                "phuho",
////                "PS16091"); 
//        
////        XJdbc.update("Delete nguoihoc where manh = ?", "PS16095");
//        
////        select("Select * from nguoihoc where manh = ?", "PS1");
//        
////        ResultSet rs = XJdbc.query("{CALL sp_ThongKeNguoiHoc}");
////        while(rs.next()) {
////            System.out.println("Năm: " + rs.getObject(1));
////            System.out.println("Số lượng: " + rs.getObject(2));
////            System.out.println("Đầu tiên: " + rs.getObject(3));
////            System.out.println("Cuối Cùng: " + rs.getObject(4));
////        }
//    }
    
    public static void insertDemo() {
        try {
            for(int i = 1; i <= 5; i++) {
                XJdbc.update("insert into nguoihoc (MaNH, HoTen, NgaySinh, GioiTinh, DienThoai, Email, GhiChu, MaNV) values(?, ?, ?, ?, ?, ?, ?, ?)", 
                "PS1609" + i,
                "Phú Hồ " + i,
                XDate.toDate("16/09/2002", "dd/mm/yyyy"),
                true,
                "0123456789",
                "phu" + i + "@gmail.com",
                "Nghèo",
                "phuho");  
            }            
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
    
    public static void select(String sql, Object...value) throws Exception{
        try {
            ResultSet rs = XJdbc.query(sql, value);
            while(rs.next()) {
                System.out.println("Mã người học: " + rs.getObject(1));
                System.out.println("Họ tên: " + rs.getObject(2));
                System.out.println("Ngày sinh: " + rs.getObject(3));
                String gioitinh = rs.getBoolean(4) ? "Nam" : "Nữ";
                System.out.println("Giới tính: " + gioitinh);
                System.out.println("SĐT: " + rs.getObject(5));
                System.out.println("Email: " + rs.getObject(6));
                System.out.println("Ghi chú: " + rs.getObject(7));
                System.out.println("Nhân viên: " + rs.getObject(8));
                System.out.println("Ngày đăng ký: " + rs.getObject(9));
                System.out.println("===============================");
            }
        } catch (Exception e) {
            throw new Exception(e.getMessage());
        }
    }
}
