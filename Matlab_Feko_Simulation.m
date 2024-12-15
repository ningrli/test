%% Matlab和FEKO联合仿真
project_name='Sphere';  % 与FEKO工程名一致
prestr='#Phiangle_start=';  % .pre文件中定义的变量名
range_interval=5;  % 目标每次移动的距离间隔
N=72;  % 共移动N次

%% 对.pre文件中的变量进行修改
for i=1:1:N
    fid_r=fopen([project_name '.pre'],'r'); % 定义读文件指针
    fid_w=fopen([project_name '.tmp'],'w'); %定义写文件指针

    while ~feof(fid_r) %如果不是文件的结尾就继续循环
        line_r=fgetl(fid_r); % 遍历每一行的值
        g=strfind(line_r,prestr); % 是否是需要修改的那一行
        if g>0 % 如果是需要修改的那一行，则在if…end区间修改这一行的值
            newvalue=num2str((i-1)*range_interval);
            line_r=strcat(prestr,newvalue); % 更改变量的值
        end
        fprintf(fid_w,'%s\n',line_r); % 通过fprintf语句把line_r的值写入fid_w指向的文件OneSpiralAnt.tmp中
    end %结束读写脚本文件循环

    fclose(fid_r); % 关闭读文件指针
    fclose(fid_w); % 关闭写文件指针

    %形成新的.pre文件
    new_file_name=strcat([project_name '_'], num2str(i));
    new_file_full_name=strcat(new_file_name,'.pre');
    % 把文件.tmp中的内容拷贝到new_file_name中，即生成N个.pre文件中
    copyfile([project_name '.tmp'],new_file_full_name);

    % addpath D:\FEKO\feko\bin\ %该命令可以将指定目录的路径临时添加到matlab的搜索路径(不改变maltab的当前路径)．

    dos(['D:\SoftWare\Altair\2021.1\feko\bin\prefeko',' ', new_file_full_name]);
    dos(['D:\SoftWare\Altair\2021.1\feko\bin\runfeko',' ', new_file_full_name,' -np all']);  % ' -np all' 调用所有的核
end
