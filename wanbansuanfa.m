%% 参数输入
function [xpe,ype,lfUZ,lfDZ] = wanbansuanfa(TVP_x,TVP_y,TVP_z,CZmd,LFsl)
 % TVP_x 定义船板型值点的x轴坐标 
 % TVP_y 定义船板型值点的y轴坐标
 % TVP_z 定义船板型值点的z轴坐标 
 % CZmd 船板的插值密度，一般大于等于3
 % LFsl 船板展开的裂缝数量，根据板的大小而定
 % xpe,ype 板展开后船板的坐标值
 % lfUZ 船板上板边裂缝总合
 % lfDZ 船板下板边裂缝总合

x=TVP_x;
y=TVP_y;
z=TVP_z;
%% 将型值点转换为三维坐标
%提取x、y的最大最小值
xmax=max(x);
xmin=min(x);
ymax=max(y);
ymin=min(y);
%将导入的x、y、z值转化为相应的三维坐标值（若是excel表格内形式用此方法计算）
% n=size(y,2);           %计算坐标点的总数量
% for i=2:n
%     if y(i)==y(1)
%         ny=i-1;
%     end
% end
% ny=ny;   
% nx=n/ny;              %x轴方向上的坐标总数量
%x1=reshape(x,ny,nx);
%x=x1(1,:);
%y1=reshape(y,ny,nx);
%y=y1(:,1);
%y=y';
%z=reshape(z,ny,nx);
nx=size(x,2);       %计算坐标点的数量
ny=size(y,2);
%% 根据三维点构造NURBS曲面
% % 控制点
% pnts=zeros(3,nx,ny);
% for j=1:1:ny
%    for i=1:1:nx
%       xc(i)=x(i);
%       yc(i)=y(j);
%       zc(i)=z(j,i);
%    end
%    pnts1(:,:,j)=[xc;yc;zc];        %曲面的三维点坐标
% end
% % 节点1
% for i=1:1:nx+1
%     if i==1
%         kx(i)=0;
%     else if i<=nx   
%         kx(i)=(i-1)/nx;
%         else
%             kx(i)=1;           %x方向的节点
%         end
%     end
% end
% for i=1:1:ny+1
%     if i==1
%         ky(i)=0;
%     else if i<=ny
%        ky(i)=(i-1)/ny;
%         else
%             ky(i)=1;           %y方向的节点
%         end
%     end
% end
% kx1=kx;
% ky1=ky;
% knots1{1} = kx1;           %x方向的节点
% knots1{2} = ky1;           %y方向的节点 
% srf1 = nrbmak(pnts1,knots1);          % 根据控制点和节点构造NURBS        
% % 作图
% figure(1)
% nrbplot(srf1,[nx ny]);
% title('根据型值点构造的NURBS曲面')
% xlabel('X'), ylabel('Y'), zlabel('Z')
%% 插值曲面
%插值
x0=abs(x(2)-x(1));
y0=abs(y(2)-y(1));
nm=CZmd;                   %插值密度，即网格加密数量
t1=x0/nm;                  %x方向的插值密度
t2=y0/nm;                  %y方向的插值密度
n1=ceil((xmax-xmin)/t1);   %根据插值密度对曲面进行均匀划分  
n2=ceil((ymax-ymin)/t2);
tx=(xmax-xmin)/n1;         %均匀分布后的x方向的最终网格密度
ty=(ymax-ymin)/n2;         %均匀分布后的x方向的最终网格密度
nx=n1+1;                   
ny=n2+1;
x1=[xmin:tx:xmax];         %对x轴、y轴进行插值
y1=[ymin:ty:ymax];
[x2,y2]=meshgrid(x1,y1);    %产生格点矩阵
z2=interp2(x,y,z,x2,y2,'spline');       %通过插值得出相应的z坐标
% %插值点
% pnts=zeros(3,nx,ny);          % 插值后曲面的坐标点
% for j=1:1:ny
%    for i=1:1:nx
%       xi(i)=x1(i);
%       yi(i)=y1(j);
%       zi(i)=z2(j,i);
%    end
%    pnts2(:,:,j)=[xi;yi;zi];
% end
% %节点2
% for i=1:1:(nx+1)
%    if i==1
%         kx(i)=0;
%     else if i<=nx   
%         kx(i)=(i-1)/nx;
%         else
%             kx(i)=1;
%         end
%     end
% end
% for i=1:1:ny+1
%     if i==1
%         ky(i)=0;
%     else if i<=ny
%        ky(i)=(i-1)/ny;
%         else
%             ky(i)=1;
%         end
%     end
% end
% kx2=kx;
% ky2=ky;
% knots2{1} = kx2;           %插值后节点
% knots2{2} = ky2;
% srf2 = nrbmak(pnts2,knots2);    %根据控制点和节点构造NURBS 
% isrf=nrbkntins(srf2,{[kx2] [ky2]});  %节点插入/细化
% figure(2)
% nrbplot(isrf,[n1 n2]);
% title('插值后NURBS曲面')
% xlabel('X'), ylabel('Y'), zlabel('Z')

%% 板展开
nf=LFsl;       %裂缝数量
nx=nf+1;       %x轴网格数量
ny=n2;         %y轴网格数量
if (mod(ny,2)==0)
    yz=y2(ceil(ny/2));
    y3=yz+ty;
    y4=yz-ty;
     n=ny-2;              %寻点数量
else 
    y3=y2(ceil(ny/2)+1);
    y4=y2(ceil(ny/2));
    n=ny+1;
end
% 各单元的展开
for i=1:1:nx
    if i==1
        x=xmax;
        yU=y3;
        xpU=x;
        [xpUF ypUF]=xundianUF(x,yU,z2,xpU,xmin,ymin,tx,ty,n);   %得出初始单元向上展开后的部分
        yD=y4;
        xpD=x;
        [xpDF ypDF]=xundianDF(x,yD,z2,xpD,xmin,ymin,tx,ty,n-4);   %得出初始单元向下展开后的部分
        xp=[xpUF,xpDF];
        yp=[ypUF,ypDF];
        xpn(i,:)=xp;
        ypn(i,:)=yp;
    else
        x(i)=x(i-1)-tx;
        yU(i)=y3; 
        xpU=xpn(i-1,4);
        [xpUF ypUF]=xundianUF(x(i),yU(i),z2,xpU,xmin,ymin,tx,ty,n);
        yD(i)=y4;
        xpD=xpn(i-1,9);
        [xpDF ypDF]=xundianDF(x(i),yD(i),z2,xpD,xmin,ymin,tx,ty,n-4);
        xp=[xpUF,xpDF];
        yp=[ypUF,ypDF];
        xpn(i,:)=xp;
        ypn(i,:)=yp;
        lfU(i-1)=xpn(i-1,3)-xpn(i,2);     %裂缝值
        lfD(i-1)=xpn(i-1,8)-xpn(i,7);
    end   
end
% 板展开裂缝值求和
for i=1:1:nf
    if i==1
        lfUZ=lfU(i);
        lfDZ=lfD(i);
    else 
        lfUZ(i)=lfUZ(i-1)+lfU(i);   
        lfDZ(i)=lfDZ(i-1)+lfD(i);   
    end
end
lfUZ=lfUZ(nf)                 %上裂缝总长
lfDZ=lfDZ(nf)                %下裂缝总长
    
% 板展开图绘制
%figure(2)
 xp1=xpn';
 xpe=xp1(:)
 yp1=ypn';
 ype=yp1(:)
% figure(3)
 %plot(xp,yp,'k') 
 %grid on