@echo off
echo.
echo Remove all data files from the DICOM directory and reinitialize the pointers.
echo.
if not "%1"=="1" pause allow for ^C to exit
if exist *.pdu del *.pdu
FOR /D %%i IN (*) DO rmdir /s /q %%i
echo 9999999>a_write.ptr
echo 9999999>a_read.ptr
echo 9999999>b_write.ptr
echo 9999999>b_read.ptr
echo 9999999>c_write.ptr
echo 9999999>c_read.ptr
echo 9999999>d_write.ptr
echo 9999999>d_read.ptr
echo 9999999>e_write.ptr
echo 9999999>e_read.ptr
echo 9999999>f_write.ptr
echo 9999999>f_read.ptr
echo 9999999>g_write.ptr
echo 9999999>g_read.ptr
echo 9999999>h_write.ptr
echo 9999999>h_read.ptr
echo 9999999>s_write.ptr
echo 9999999>s_read.ptr
echo 9999999>t_write.ptr
echo 9999999>t_read.ptr
echo 9999999>u_write.ptr
echo 9999999>u_read.ptr
echo 9999999>v_write.ptr
echo 9999999>v_read.ptr
echo 9999999>w_write.ptr
echo 9999999>w_read.ptr
echo 9999999>x_write.ptr
echo 9999999>x_read.ptr
echo 9999999>y_write.ptr
echo 9999999>y_read.ptr
echo 9999999>z_write.ptr
echo 9999999>z_read.ptr
echo.
echo Initialization Completed
