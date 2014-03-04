nohup python shutit_main.py --image_tag ninehundred.brentford.openbet.com:5000/r36_template_2014-02-07 --shutit_module_path ../shutit_modules/openbet/:../shutit_modules/openbet/hills > /tmp/shutit.log &
tail -f /tmp/shutit.log
