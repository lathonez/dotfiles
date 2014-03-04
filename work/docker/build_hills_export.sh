nohup python shutit_main.py --image_tag stackbrew/ubuntu:quantal  --config ../shutit_modules/openbet/hills/configs/export_base.cnf --shutit_module_path ../shutit_modules/openbet/:../shutit_modules/openbet/hills > /tmp/shutit.log &
tail -f /tmp/shutit.log
