/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.edusys.dao;

import com.edusys.entity.NguoiHoc;
import com.edusys.utils.XDate;
import java.util.List;

/**
 *
 * @author phuho
 */
public class TestDAO {
    static NguoiHocDAO nguoiHocDAO = new NguoiHocDAO();
    static ThongKeDAO thongKeDAO = new ThongKeDAO();
    
//    public static void main(String[] args) {
////        insertDemo();
////        updateDemo();
////        deleteDemo("PS4");
////        selectAllDemo();
////        selectProcDemo();
//        
//    }
    
    public static void selectProcDemo() {
        List<Object[]> list = thongKeDAO.getLuongNguoiHoc();        
    }
    
    public static void selectAllDemo() {
        List<NguoiHoc> list = nguoiHocDAO.selectAll();
        for(var nguoiHoc: list) {
            System.out.println("Mã người học: " + nguoiHoc.getMaNH());
            System.out.println("Họ tên: " + nguoiHoc.getHoTen());
            System.out.println("Ngày sinh: " + nguoiHoc.getNgaySinh());
            String gioitinh = nguoiHoc.getGioiTinh() ? "Nam" : "Nữ";
            System.out.println("Giới tính: " + gioitinh);
            System.out.println("SĐT: " + nguoiHoc.getDienThoai());
            System.out.println("Email: " + nguoiHoc.getEmail());
            System.out.println("Ghi chú: " + nguoiHoc.getGhiChu());
            System.out.println("Nhân viên: " + nguoiHoc.getMaNV());
            System.out.println("Ngày đăng ký: " + nguoiHoc.getNgayDK());
            System.out.println("===============================");
        }
    }
    
    public static void deleteDemo(String maNH) {
        nguoiHocDAO.delete(maNH);
    }
    
    public static void updateDemo() {
        NguoiHoc nguoiHoc = new NguoiHoc();
            nguoiHoc.setMaNH("PS1");
            nguoiHoc.setHoTen("Phú Hồ");
            nguoiHoc.setNgaySinh(XDate.toDate("16/09/2002", "dd/mm/yyyy"));
            nguoiHoc.setGioiTinh(true);
            nguoiHoc.setDienThoai("0123891724");
            nguoiHoc.setEmail("phuho@gmail.com");
            nguoiHoc.setGhiChu("Cận nghèo");
            nguoiHoc.setMaNV("phuho");
        nguoiHocDAO.update(nguoiHoc);
    }
    
    public static void insertDemo() {
        for(int i = 1; i <= 5 ;i++) {
            NguoiHoc nguoiHoc = new NguoiHoc();
            nguoiHoc.setMaNH("PS" + i);
            nguoiHoc.setHoTen("Phú Hồ " + i);
            nguoiHoc.setNgaySinh(XDate.toDate("16/09/2002", "dd/mm/yyyy"));
            nguoiHoc.setGioiTinh(true);
            nguoiHoc.setDienThoai("0123891724");
            nguoiHoc.setEmail("phu" + i + "@gmail.com");
            nguoiHoc.setGhiChu("nghèo");
            nguoiHoc.setMaNV("phuho");
            
            try {
                nguoiHocDAO.insert(nguoiHoc);
            } catch (Exception e) {
                System.out.println(e.getMessage());
            }
        }
    }
}
