function [xp3 yp3]=qiudian(xa3,ya3,za3,xb3,yb3,zb3,xc3,yc3,zc3,xa2,ya2,xb2,yb2)
%已知空间曲面三个点的三维坐标和平面两个点的坐标，根据空间三角形和平面三角形
%对应的边边长长度都相同，求解出平面三角形未知点的坐标。

syms xc2 yc2
A3B3=sqrt((xb3-xa3)^2+(yb3-ya3)^2+(zb3-za3)^2);
A3C3=sqrt((xc3-xa3)^2+(yc3-ya3)^2+(zc3-za3)^2);
B3C3=sqrt((xc3-xb3)^2+(yc3-yb3)^2+(zc3-zb3)^2);
A2B2=sqrt((xb2-xa2)^2+(yb2-ya2)^2);
A2C2=sqrt((xc2-xa2)^2+(yc2-ya2)^2);
B2C2=sqrt((xc2-xb2)^2+(yc2-yb2)^2);
[xc2 yc2]=solve('xc2^2-2*xc2*xa2+xa2^2+yc2^2-2*yc2*ya2+ya2^2=A3C3^2','xc2^2-2*xc2*xb2+xb2^2+yc2^2-2*yc2*yb2+yb2^2=B3C3^2','xc2','yc2');
xp3=subs(xc2);
yp3=subs(yc2);



