package com.edusys.entity;

public class NhanVien {

    private String maNV;
    private String matKhau;
    private String hoTen;
    private String Email;
    private String VerifyQMK;
    private boolean vaiTro = false;

    public String getMaNV() {
        return maNV;
    }

    public String getEmail() {
        return Email;
    }

    public String getVerifyQMK() {
        return VerifyQMK;
    }

    public void setVerifyQMK(String VerifyQMK) {
        this.VerifyQMK = VerifyQMK;
    }

    public void setEmail(String Email) {
        this.Email = Email;
    }

    public void setMaNV(String maNV) {
        this.maNV = maNV;
    }

    public String getMatKhau() {
        return matKhau;
    }

    public void setMatKhau(String matKhau) {
        this.matKhau = matKhau;
    }

    public String getHoTen() {
        return hoTen;
    }

    public void setHoTen(String hoTen) {
        this.hoTen = hoTen;
    }

    public boolean getVaiTro() {
        return vaiTro;
    }

    public void setVaiTro(boolean vaiTro) {
        this.vaiTro = vaiTro;
    }
}
