
--Submitted By-

--Priyali Tambe

---DATABASE for University Enterprise---


--Step 1: Create table - Department_info--
create table Department_info(
department_name varchar(50),
building_name varchar(50),
budget_alloted int,
PRIMARY KEY (department_name))

--Step 2: Add vakues to table - Department_info--

INSERT INTO Department_info VALUES('ANTHROPOLOGY', 'Douglas Hall',250000);
INSERT INTO Department_info VALUES('Information & Decision Sciences', 'Burnham Hall',500000);
INSERT INTO Department_info VALUES('Applied Physics','Lecture Centre C',200000);
INSERT INTO Department_info VALUES('Architecture and Arts', 'Lecture Centre D',80000);
INSERT INTO Department_info VALUES('Medicine','Lecture Centre E',650000);
INSERT INTO Department_info VALUES('Chemistry','Lecture Centre F',600000);


SELECT * FROM Department_info ORDER BY building_name;

--Step 3: Create table - Course--
create table Course(
course_id int,
name_of_course varchar(30),
course_credits int,
prerequisite_id  int,
course_department varchar(50),
CONSTRAINT course_department_fk FOREIGN KEY (course_department) REFERENCES Department_info(department_name),
PRIMARY KEY (course_id)
)

--Step 4: Add values to table - Course--

INSERT INTO Course VALUES(221, 'Advanced Database MS',8,123,'Information & Decision Sciences');
INSERT INTO Course VALUES(530,'Statistics for Managers',8,225,'Information & Decision Sciences');
INSERT INTO Course VALUES(577,'Data Mining for Data Scientists',8,400,'Information & Decision Sciences');
INSERT INTO Course VALUES(533,'Astrophysics',8,350,'Applied Physics');
INSERT INTO Course VALUES(568,' Archeology ',8,461,'ANTHROPOLOGY');
INSERT INTO Course VALUES(569,' Forensics ',4,462,'ANTHROPOLOGY');
INSERT INTO Course VALUES(444,' Organic',4,442,'Chemistry');
INSERT INTO Course VALUES(578, 'Network Analytics', 4, 665, 'Information & Decision Sciences');
INSERT INTO Course VALUES(588, 'Machine Learning Fundamentals' , 4, 440, 'Information & Decision Sciences');
INSERT INTO Course VALUES(590, 'MLOps', 8, 502, 'Information & Decision Sciences');
INSERT INTO Course VALUES(493, 'Text Analytics', 4, 502, 'Information & Decision Sciences');
INSERT INTO Course VALUES(499, 'Capstone', 4, 512, 'Information & Decision Sciences');

SELECT * FROM Course ;

--Step 5:Create table- Instructor_info--
create table Instructor_info(
instructor_ID int,
instructor_name varchar(30),
instructor_salary int,
instructor_department varchar(50),
CONSTRAINT instructor_department_fk FOREIGN KEY (instructor_department) REFERENCES Department_info(department_name),
PRIMARY KEY (instructor_ID)
)

--Step 6: Add values to table- Instructor_info--

INSERT INTO Instructor_info VALUES(112,'Harry Potter',60000,'Information & Decision Sciences');
INSERT INTO Instructor_info VALUES(256,'Hermione Grainger',35000,'ANTHROPOLOGY');
INSERT INTO Instructor_info VALUES(553,'Ron Weasely',70000,'Medicine');
INSERT INTO Instructor_info VALUES(441,'Voldemort',65000,'Applied Physics');
INSERT INTO Instructor_info VALUES(577,'Dumbledore',55000,'Medicine');
INSERT INTO Instructor_info VALUES(689,'Luca Malfoy',85000,'Information & Decision Sciences');
INSERT INTO Instructor_info VALUES(741,'Dr Hagrid',52500,'ANTHROPOLOGY');
INSERT INTO Instructor_info VALUES(123,'Dr Umbridge',52000,'Applied Physics');
INSERT INTO Instructor_info VALUES(111, 'Dr Snape',90000,'Information & Decision Sciences');


SELECT * FROM Instructor_info ;

--Step 7:Create table - Student_info--

create table Student_info(
student_ID int,
student_name varchar(30),
total_credits int,
advisor_name int,
student_department varchar(50),
grade varchar(5),
section_ID int,
CONSTRAINT advisor_name_fk FOREIGN KEY (advisor_name) REFERENCES Instructor_info(instructor_ID),
CONSTRAINT student_department_fk FOREIGN KEY (student_department) REFERENCES Department_info(department_name),
PRIMARY KEY (student_ID),
)
Alter Table [dbo].[Student_info]  with check add constraint [check_grade] check (([grade]='O' OR [grade]='E' OR [grade]='A' OR [grade]='B' OR [grade]='C'OR [grade]='F'))



--Step 8: Add values to table - Student_info--

INSERT INTO Student_info VALUES(11,'Diana',24,112,'Information & Decision Sciences','O',1);
INSERT INTO Student_info VALUES(24,'Charles',32,256,'ANTHROPOLOGY','E',2);
INSERT INTO Student_info VALUES(31,'Elizabeth',48,577,'Information & Decision Sciences','O',3);
INSERT INTO Student_info VALUES(74,'Philip',36,441,'Medicine','E',4);
INSERT INTO Student_info VALUES(85,'Anne',72,577,'Information & Decision Sciences','O',1);
INSERT INTO Student_info VALUES(66,'Margaret',96,256,'ANTHROPOLOGY','E',2);
INSERT INTO Student_info VALUES(72,'Andrew',32,441,'Applied Physics','O',3);
INSERT INTO Student_info VALUES(81,'Meghan',24,112,'Medicine','E',4);
INSERT INTO Student_info VALUES(12,'Edward',72,123,'Applied Physics','O',3);
INSERT INTO Student_info VALUES(13,'Victoria',42,123,'Medicine','E',4);

SELECT * FROM Student_info;

--Step 9:Create table - Time_slot--

create table Time_slot(
time_slot_ID int,
day char(15), 
start_time time,
end_time time,
PRIMARY KEY (time_slot_ID)
)
Alter table [dbo].[Time_slot]  with check add constraint [check_day] check (([day]='MONDAY' OR [day]='TUESDAY' OR [day]='WEDNESDAY' OR [day]='THURSDAY' OR [day]='FRIDAY' OR [day]='SATURDAY' OR [day]='SUNDAY'))

--Step 10 : Add values to table - Time_slot--
INSERT INTO Time_slot values (11,'THURSDAY','17:15:23','10:30:00');
INSERT INTO Time_slot values (32,'FRIDAY','13:00:00','11:30:00');
INSERT INTO Time_slot values (56,'MONDAY','14:00:00','11:00:00');
INSERT INTO Time_slot values (82,'TUESDAY','16:00:00','22:20:00');
INSERT INTO Time_slot values (62,'SATURDAY','15:15:00','23:15:00');
INSERT INTO Time_slot values (21,'WEDNESDAY','10:00:00','21:30:00');
INSERT INTO Time_slot values (72,'TUESDAY','17:00:00','22:20:00');
INSERT INTO Time_slot values (33,'SATURDAY','14:15:00','23:15:00');
INSERT INTO Time_slot values (22,'WEDNESDAY','11:00:00','21:30:00');


select * from Time_slot;

--Step 11:Create table - Classroom--

create table Classroom(
building_name varchar(100),
room_number varchar(50) NOT NULL unique,
capacity int
PRIMARY KEY (building_name)
);

--Step 12: Add values to table - Classroom--
INSERT INTO Classroom values('Morgan Room','25',70);
INSERT INTO Classroom values('Taylor Room','34',60);
INSERT INTO Classroom values('Sadie forum','241',80);
INSERT INTO Classroom values('Halsted Room','215',100);
INSERT INTO Classroom values('Polk Room','58',55);
INSERT INTO Classroom values('Clark Room','44',65);
INSERT INTO Classroom values('Henry Hall','38',75);

select * from Classroom;

--Step 13:Create table - Section--

create table Section(
section_ID int,
semester int,
year date,
section_course int,
section_time_slot int,
Instructor_info_ID int,
section_class varchar(100),
CONSTRAINT section_course_fk FOREIGN KEY (section_course) REFERENCES Course(course_id),
CONSTRAINT section_time_slot_fk FOREIGN KEY (section_time_slot) REFERENCES Time_slot(time_slot_ID),
CONSTRAINT section_class_fk FOREIGN KEY (section_class) REFERENCES Classroom(building_name),
CONSTRAINT Instructor_ID_fk FOREIGN KEY (Instructor_info_ID) REFERENCES Instructor_info(instructor_ID)
);

--Step 13: Add values to table - Section--
INSERT INTO Section values(11,1,'2020',221,11,112,'Morgan Room');
INSERT INTO Section values(22,3,'2022',530,32,256,'Taylor Room');
INSERT INTO Section values(44,3,'2019',578,32,441,'Halsted Room');
INSERT INTO Section values(55,2,'2018',499,11,689,'Clark Room');
INSERT INTO Section values(66,2,'2018',499,32,111,'Clark Room');

select * from Section;

--------------FINAL STEP---------------
---Let us insert some select queries---


--1. List of all instructors whose name starts with an H.
 
SELECT * FROM Instructor_info
WHERE instructor_name LIKE 'H%';
 
--2. List the student name, grade, and total credits taken in the IDS department.
 
SELECT student_name, grade, total_credits FROM Student_info 
WHERE student_department = 'Information & Decision Sciences';
 
-- 3. List the number of enrolled students by each department.
 
SELECT student_department, COUNT(student_ID) AS number_of_students 
FROM Student_info GROUP BY student_department;
 
--4. Display the tuple of a student named Victoria.
 
SELECT * FROM Student_Info WHERE student_name = 'Victoria';
 
--5. Find the advisor name(s) of a student named Victoria.
 
SELECT i.instructor_name FROM Instructor_info i, Student_info s WHERE i.instructor_id = s.advisor_name AND s.student_name = 'Victoria';
 
--6. List the name of Students with more than 12 credits.
 
SELECT student_name, total_credits FROM Student_info WHERE total_credits > 12;
 
-- 7. Find the average credits taken by a student.
 
SELECT AVG(total_credits) AS average_credits FROM Student_info;
 
-- 8.List the instructors with a salary that is greater than 64000.
 
SELECT instructor_name, instructor_salary FROM Instructor_info WHERE instructor_salary > 64000;
 
-- 9. List the number of professors from each department.
 
SELECT department_name AS department, COUNT (i.instructor_ID) AS number_of_instructors
	FROM Department_info d
	JOIN Instructor_info i
	ON d.department_name = i.instructor_department
	GROUP BY department_name;
 
--10. List the average salary of an instructor from each department. 
 
SELECT department_name AS department, AVG(instructor_salary) AS average_salary
	FROM Instructor_info ins
	JOIN Department_info dep
	ON ins.instructor_department = dep.department_name
	GROUP BY department_name;
 
-- 11. Display the department with the least budget.
 
SELECT * FROM Department_info 
WHERE budget_alloted = (SELECT MIN(budget_alloted) FROM Department_info);
 
-- 12. Find the total number of registered students in each course.
 
SELECT c.name_of_course AS course, COUNT (s.student_ID) AS number_of_students 
	FROM Department_info d, Student_info s, Course c 
	WHERE d.department_name = s.student_department AND c.course_department = d.department_name 
	GROUP BY c.name_of_course;
 
-- 13. List the courses which are not four-credit courses.
 
SELECT * FROM Course WHERE NOT course_credits = 4;
 
-- 14. Display the section tuple for the second semester of 2018.
 
SELECT * FROM Section WHERE semester = 2 AND year = '2018';
 
-- 15. List all students with a grade of E. 
 
SELECT s.student_name, grade FROM Student_info s WHERE grade IN ('E');
 
-- 16. Display all records in which the classroom and the day falls in time slot 11.
 
SELECT sec.section_class, t.day FROM Section sec, Time_slot t
	WHERE t.time_slot_ID = sec.section_time_slot AND section_time_slot = 11;
 
-- 17. Displays all courses in the Applied Physics and Chemistry department.
 
SELECT * FROM Course
WHERE course_department IN ('Applied Physics', 'Chemistry');
 
-- 18. Find the maximum credits taken in each department.
 
SELECT department_name as department, MAX(course_credits) as maximum_credits
	FROM Department_info d
	JOIN Course s
	on d.department_name = s.course_department
	GROUP BY department_name;
 
-- 19. Display the average capacity of a classroom.
  
SELECT AVG(capacity) FROM Classroom;
 
-- 20. List all instructors who are also advisors. 
 
SELECT instructor_name AS advisor_name FROM Instructor_info
	WHERE instructor_ID IN (SELECT instructor_ID FROM Student_info);


	--END of HW3--
