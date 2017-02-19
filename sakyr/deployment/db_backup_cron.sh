#!/bin/bash
cd /home/navyug/projects/rails-ember-boilerplate/deployment
source /home/navyug/.bash_profile
cap local tasks:db_dump
