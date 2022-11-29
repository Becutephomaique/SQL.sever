SELECT        dbo.KhoaKham.MaKhoa, dbo.KhoaKham.TenKhoa, dbo.KhoaKham.SoBenhNhan, dbo.BenhNhan.GioiTinh
FROM            dbo.BenhNhan INNER JOIN
                         dbo.KhoaKham ON dbo.BenhNhan.MaKhoa = dbo.KhoaKham.MaKhoa
WHERE        (dbo.BenhNhan.GioiTinh = 0)