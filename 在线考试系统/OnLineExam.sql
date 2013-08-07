if exists(select * from sysdatabases where name='OnLineExam')
  drop database OnLineExam
create database OnLineExam
go
use OnLineExam
go
--�˱������洢�û��Ļ�����Ϣ
create table UserInfo
(
	UserID Varchar(20) primary key,--��¼��
	UserName Varchar(50) not null,--�û�����
	UserPwd varchar(50) not null,--����
	RoleId int not null,--��ɫ
	ID int--�ʺ�ID
)
select*from	UserInfo
insert UserInfo values('admin','����','123',3,2)
insert UserInfo values('hero','����','123',1,1)
insert UserInfo values('tea','����','123',2,3)
create table UserDetails
(
	ID int primary key,
	userId Varchar(20) foreign key (userId) references UserInfo(UserId) on delete cascade
)
--�˱������洢�û��Ľ�ɫ��Ȩ����Ϣ
create table Role
(
	RoleID Int primary key,--��ɫ���
	RoleName Varchar(50) not null,--��ɫ����
	HasDuty_DepartmentManage varchar(50),--���Ź���
	HasDuty_userManage bit,--�����û�Ȩ��
	HasDuty_Role bit,--�����ɫȨ��
	HasDuty_userScore bit,--�����û��ɼ�Ȩ��
	HasDuty_courseManage bit,--����γ�Ȩ��
	HasDuty_paperSetup bit,--�Ծ�����Ȩ��
	HasDuty_paperLists bit,--�����Ծ�Ȩ��
	HasDuty_userPaperList bit,--�Ծ�����
	HasDuty_QuestionManage bit--��������Ȩ��
)
insert Role values(1,'student','',0,0,0,0,0,0,0,0)
insert Role values(2,'teacher','',0,0,0,0,0,0,0,0)
insert Role values(3,'admin','',1,1,1,1,1,1,1,1)
select RoleID, CONVERT(int,HasDuty_userManage),CONVERT(int,HasDuty_Role),CONVERT(int,HasDuty_userScore),CONVERT(int,HasDuty_paperSetup),CONVERT(int,HasDuty_paperLists),CONVERT(int,HasDuty_userPaperList),CONVERT(int,HasDuty_QuestionManage) from Role
select*from Role 
--�˱������洢���Կγ���Ϣ
create table Course
(
	courseID int primary key,--���
	courseName Varchar(200) not null--�γ���
)

insert Course values(1,'����')
insert Course values(2,'��ѧ')
--�˱������洢�Ծ���Ϣ��Ϣ 
create table Paper
(
	PaperID int primary key,--�Ծ���
	courseID int not null,--�γ̱��
	PaperName varchar(200),--�Ծ���
	PaperState bit,--�Ծ�״̬
	ExamTime Varchar(20) not null--����ʱ��
)
select courseName,PaperName,PaperState from Paper left join Course on Paper.courseID=Course.courseID
insert Paper values(1,1,'����A',0,'2010-07-01')
insert Paper values(2,1,'����B',0,'2010-07-01')

--�˱������洢�Ծ���ϸ��Ϣ 
create table PaperDetail
(
	ID int primary key,--�Ծ���
	PaperID int foreign key (PaperID) references Paper(PaperID) not null,--�Ծ���
	type varchar(50) ,--��Ŀ����
	titleID int not null,--�Ծ����
	Mark int not null,--ÿ���ֵ
	WriteTime int not null--����ʱ��
) 
--�˱������洢 �û��ɼ���Ϣ
create table score
(
	ID int primary key,--���
	PaperID int not null,--�Ծ���
	userID varchar(50) not null,--�û����
	Score float not null,--�Ծ�ɼ�
	examTime Varchar(20),--����ʱ��
	JudgeTime datetime--����ʱ��
) 
select UserInfo.UserID,UserName,PaperID,Score,examTime,JudgeTime from UserInfo right join score on UserInfo.UserID=score.userID where 1=1 and PaperID=1
--�˱������洢�û��������Ϣ
create table UserAnswer
(
	ID int primary key,--���
	PaperID int not null,--�Ծ���
	userID varchar(50) not null,--�û����
	Type Varchar(50) not null,--��Ŀ����
	examTime Varchar(20) not null,--����ʱ��
	TitleID int not null,--����
	Mark int not null,--��ֵ
	answer Varchar(1000) not null--��
)
select SUM(Mark) from UserAnswer left join judgeProblem on UserAnswer.TitleID=judgeProblem.ID where UserAnswer.answer=CONVERT(varchar(1000) ,judgeProblem.answer)
select PaperDetail.*,courseID,Title,answer from PaperDetail left join questionProblem on PaperDetail.TitleID=questionProblem.ID 
select distinct PaperName,UserAnswer.examTime from UserAnswer left join Paper on UserAnswer.PaperID=Paper.PaperID
insert UserAnswer values('1','1','hero','judgeProblem','2010-07-01','1','2','1')
insert UserAnswer values('2','1','hero','asssd','2010-07-01','1','2','asdsa')
select distinct RANK()over(order by UserName) as ID,  UserName,examTime from UserAnswer inner join UserInfo on UserInfo.UserID=UserAnswer.userID
select identity(int,1,1) as ID,Title,UserAnswer.answer as useranswer,questionProblem.answer,CAST('' as int) score into a from UserAnswer left join questionProblem on UserAnswer.TitleID=questionProblem.ID 
select SUM(score) from a
drop table a
--�˱������洢��ѡ����Ϣ
create table singleProblem
(
	ID int primary key,--���
	courseID int foreign key(courseID) references Course(courseID) not null,--�γ̱��
	title varchar(1000) not null,--��Ŀ
	answerA Varchar(500) not null,--ѡ��A
	answerB Varchar(500) not null,--ѡ��B
	answerC Varchar(500) not null,--ѡ��C
	answerD Varchar(500) not null,--ѡ��D
	answer Varchar(2) not null--��ȷ��
) 
create table multiProblem
(
	ID int primary key,--���
	courseID int foreign key(courseID) references Course(courseID) not null,--�γ̱��
	title varchar(1000) not null,--��Ŀ
	answerA Varchar(500) not null,--ѡ��A
	answerB Varchar(500) not null,--ѡ��B
	answerC Varchar(500) not null,--ѡ��C
	answerD Varchar(500) not null,--ѡ��D
	answer Varchar(50) not null--��ȷ��
) 
--�˱������洢�ж�����Ϣ
create table judgeProblem
(
	ID int primary key,--���
	courseID int foreign key(courseID) references Course(courseID) not null,--�γ̱��
	title varchar(1000) not null,--��Ŀ
	answer Bit not null--��ȷ��
)
select *from judgeProblem
--�˱������洢�������Ϣ
create table fillBlankProblem
(
	ID int primary key,--���
	courseID int foreign key(courseID) references Course(courseID) not null,--�γ̱��
	FrontTitle varchar(500) not null,--�ո�֮ǰ����Ŀ
	backTitle Varchar(500) not null,--�ո�֮�����Ŀ
	answer Varchar(200) not null--��ȷ��
)
--�˱������洢 �ʴ�����Ϣ
create table questionProblem
(
	ID int primary key,--���
	courseID int foreign key(courseID) references Course(courseID) not null,--�γ̱��
	Title varchar(1000) not null,--��Ŀ
	answer Varchar(1000) not null--��ȷ��
)

create proc proc_getUser
	@userID varchar(20),
	@userPwd varchar(50)
as
	if(exists(select*from UserInfo where UserID=@userID and UserPwd=@userPwd))
	return 1
	else
	return 1
go
select top 3 *from UserInfo order by NEWID()