#!/bin/bash

function createFolder() {
### GO TO PROJECTS DIRECTORY AND LIST EXISTING PROJECTS
cd ./Documents/projects
echo "Existing projects are:"
sleep 0.75
echo -n
ls
sleep 0.75
### ENTERING PROJECT NAME
echo "Enter Project name"
read fname
### DETECTING IF ANY PROJECT HAS THE SAME NAME
if [ -d '$fname' ]
	then
	echo "Project Exists"
### PROJECT CREATION
else
`mkdir $fname`
	echo "Project Created"
	sleep 0.75
### GO TO PROJECT
	cd ./$fname
	echo "Your current location is:"
	sleep 0.75
	pwd
fi

}

function venv(){
### CREATION OF VIRTUAL ENVIRONMENT
echo "Enter virtual environment name: "
read env
python3 -m venv $env
source ./env/bin/activate ### ACTIVATION OF VIRTUAL ENV
echo "Virtual environment is activated"
pip install django ### DJANGO
pip freeze
sleep 0.75


### DJANGO PROJECT CREATION
echo "Enter Django Project name"
read project
django-admin startproject $project
echo "Bash Script deactivates virtual environment after installation of library and django project"
echo "re-activate using source ./env/bin/activate to install more libraries"
cd ./$project ### GOING TO PROJECT DIRECTORY
}

function app(){
### ASK IF YOU NEED AN APPLICATION CREATED
echo "Would you want to create an application?"
echo "type 'yes' or 'no'"
read arg
### IF YES
	if [[ $arg = "yes" ]]
	then
	echo "enter application name: "
	read app
	django-admin startapp $app
### CONFIGURE PROJECT SETTINGS
### ADD APPLICATION IN INSTALLED APPLICATIONS
	dir="$PWD"
	base="$(basename "$dir")"
	cd ./$base
	ex settings.py <<-eof ### NOTE THAT EOF MUST NOT BE INDENTED, ADD "-"
	39 insert
	\'$app\',
	.
	xit
eof
tab="$(printf '\t')"
### INCLUDE APPLICATION URL IN PROJECT URL
	sed -i '17 s/path/path, include/' urls.py
	ex urls.py <<-eof
	21 insert
	${tab}path('', include('$app.urls'))
	.
	xit
eof
### GO TO APPLICATION DIRECTORY AND ADD urls.py
	cd ..
	cd ./$app
	touch urls.py
echo "
from django.urls import path
from . import views


urlpatterns = []
	
	" >> urls.py 
	
	echo "Application $app created successfully"
	echo "In $base settings.py, application is applied in installed applications"
	echo "urls.py in $app is created"
### IF NO
	elif [[ $arg = "no" ]]
	then
	echo "okay..."
### IF INPUTTED ANYTHING BESIDES YES AND NO
	else
	echo "Have it your own way"
fi

}
### COMMAND RUN DOWN
createFolder
venv
app
cd ..
code .




