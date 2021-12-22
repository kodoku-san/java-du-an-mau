/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.edusys.utils;

import com.edusys.dao.NhanVienDAO;
import com.edusys.entity.NhanVien;
import com.edusys.ui.LoaddingJDialog;
import javax.swing.JDialog;

/**
 *
 * @author phuho
 */
public class XVerify {
    
    public static JDialog jDialog = new LoaddingJDialog(null, true);
    private static boolean QMK = false;
    private static String Mailer = null;
    private static String ExceptionMailer = "-1";
    public static NhanVien nhanVienVerify = null;
    private static NhanVienDAO daoNhanVienVerify = new NhanVienDAO();
    
    public static void VerifiedQMK() {
        QMK = true;
    }
    
    public static void NotVerifyQMK() {
        QMK = false;
        nhanVienVerify = null;
    }
    
    public static boolean GetVerifyQMK() {
        return QMK;
    }
    
    public static void WaitVerifyMailer() {
        Mailer = "-1";
    }
    
    public static void VerifiedMailer() {
        Mailer = "1";
    }
    
    public static void NotVerifyMailer(String e) {
        Mailer = "0";
        ExceptionMailer = e;
    }
    
    public static String GetVerifyMailer() {
        return Mailer;
    }
    
    public static String GetExceptionMailer() {
        return ExceptionMailer;
    }
    
    /**
     *  Xử lý các Verify
     * 
     * @param flag là các trường hợp cần thực thi xử lý. VD: flag == "QMK" thì sẽ tạo mới 
     * một Verify Code. Sau đó gửi đến mail người sử dụng, nhằm thực hiện việc check code quên mật khẩu
     * @param agrs là các phát sinh nếu có. VD: ("clearQMK", "new pass") thì sẽ 
     * xóa Verify Code, thay đổi pass người sử dụng thành tham số truyền vào...
     */
    public static void HandleVerify(String flag, Object...agrs) {
        if(flag == "QMK") {
            int code = (int) Math.floor(((Math.random() * 8999) + 1000));
            nhanVienVerify.setVerifyQMK(String.valueOf(code));
            daoNhanVienVerify.update(nhanVienVerify);
            String content = "Xin chào " + nhanVienVerify.getHoTen() + " \n\n";
            content += "Hướng dẫn xác nhận yêu cầu lấy lại tài khoản.\n";
            content += "Bạn hãy nhập mã dưới đây vào ứng dụng để xác thực quyền sử dụng tài khoản này!\n";
            content += "Mã xác nhận của bạn là: " + code + "\n\n\n";
            content += "**Đây là mail tự động của hệ thống. Vui lòng không phản hồi mail này!";
            try {
                XMail.sendMail(nhanVienVerify.getEmail(), content, "Mã xác thực tài khoản. Đổi mật khẩu EuVN - Hệ thống quản lý đào tạo");
            } catch (Exception e) {
                MsgBox.alert(null, e.getMessage());
            }
        } else if(flag == "clearQMK" && nhanVienVerify != null) {
            nhanVienVerify.setVerifyQMK(null);
            if(agrs.length == 1 && QMK) {
                nhanVienVerify.setMatKhau(agrs[0].toString());
            }
            daoNhanVienVerify.update(nhanVienVerify);
            XVerify.NotVerifyQMK();
        }
    }
}
