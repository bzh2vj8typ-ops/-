function [xpUF ypUF]=xundianUF(x,y,z,xp,xmin,ymin,tx,ty,n)
% x：起始点的x轴坐标
% y：起始点的y轴坐标
% t：网格密度
% n：寻点的总数
% 此程序是由板某一个单元的y轴方向的中点开始，向上寻点，将板的一个单元的上半部分展开
z1=z;
for i=1:1:n
    if i==1
    xs(i)=x;                     %曲面上的三维点的x坐标
    ys(i)=y;                     %曲面上的三维点的y坐标
    a=ceil((xs(i)-xmin)/tx)+1;
    b=ceil((ys(i)-ymin)/ty)+1;
    zs(i)=z1(b,a);                %根据x坐标与y坐标确定该点的z坐标值
    xp(i)=xp;                    %向上寻点后展开平面上的x坐标
    yp(i)=ys(i);                 %向上寻点后展开平面上的y坐标
  else if i==2
          xs(i)=x-tx;
          ys(i)=y;
          a=ceil((xs(i)-xmin)/tx)+1;
          b=ceil((ys(i)-ymin)/ty)+1;
          zs(i)=z1(b,a);
        x2=sqrt((xs(i-1)-xs(i))^2+(ys(i)-ys(i-1))^2+(zs(i)-zs(i-1))^2);    %第二个点距初始点的x方向的距离
          xp(i)=xp(i-1)-x2;
          yp(i)=ys(i);
      else if i==3
           xs(i)=x;
           ys(i)=ys(i-1)+ty;
          a=ceil((xs(i)-xmin)/tx)+1;
          b=ceil((ys(i)-ymin)/ty)+1;
          zs(i)=z1(b,a);
    %调用求点函数求出展开平面上坐标值
    [xp3 yp3]=qiudian(xs(i-2),ys(i-2),zs(i-2),xs(i-1),ys(i-1),zs(i-1),xs(i),ys(i),zs(i),xp(i-2),yp(i-2),xp(i-1),yp(i-1));
            xp(i)=xp(1);
            yp(i)=yp3(2);
          else if  (mod(i,2)==0) 
              xs(i)=x-tx;
              ys(i)=ys(i-1);
              a=ceil((xs(i)-xmin)/tx)+1;
              b=ceil((ys(i)-ymin)/ty)+1;
              zs(i)=z1(b,a);
    [xp3 yp3]=qiudian(xs(i-2),ys(i-2),zs(i-2),xs(i-1),ys(i-1),zs(i-1),xs(i),ys(i),zs(i),xp(i-2),yp(i-2),xp(i-1),yp(i-1));
              xp(i)=xp3(1);
              yp(i)=yp3(1);
              else
                  xs(i)=x;
                  ys(i)=ys(i-1)+ty;
                 a=ceil((xs(i)-xmin)/tx)+1;
                 b=ceil((ys(i)-ymin)/ty)+1;
                 zs(i)=z1(b,a);
    [xp3 yp3]=qiudian(xs(i-2),ys(i-2),zs(i-2),xs(i-1),ys(i-1),zs(i-1),xs(i),ys(i),zs(i),xp(i-2),yp(i-2),xp(i-1),yp(i-1));
                  xp(i)=xp(1);
                  yp(i)=yp3(2);
              end
          end
      end
    end
end
%展开平面的坐标点
xpU=xp;
ypU=yp;
%选取展开平面的四边交点用于绘制展开的平面图
xpUF=[xp(1) xp(n-1) xp(n) xp(2) xp(1)];
ypUF=[yp(1) yp(n-1) yp(n) yp(2) yp(1)];
% plot(xpUF,ypUF)