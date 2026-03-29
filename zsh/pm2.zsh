alias pm2-start='pm2 start ecosystem.config.js'

alias pm2-full-restart='pm2 delete ecosystem.config.js && pm2 start ecosystem.config.js'

function pm2-ls() {
  pm2 jlist | python3 -c "
import json, sys
from datetime import datetime

def format_duration(ms):
    if not ms:
        return '-'

    seconds = max(int((datetime.now().timestamp() * 1000 - ms) / 1000), 0)
    days, rem = divmod(seconds, 86400)
    hours, rem = divmod(rem, 3600)
    minutes, secs = divmod(rem, 60)

    if days:
        return f'{days}d{hours}h'
    if hours:
        return f'{hours}h{minutes}m'
    if minutes:
        return f'{minutes}m{secs}s'
    return f'{secs}s'

data = json.load(sys.stdin)
headers = ['id','name','mode','↺','status','cpu','memory','uptime']
print('\t'.join(headers))
for p in data:
    env = p['pm2_env']
    monit = p.get('monit', {})
    row = [
        str(env['pm_id']),
        p['name'],
        env['exec_mode'].replace('_mode', ''),
        str(env['restart_time']),
        env['status'],
        str(monit.get('cpu', 0)) + '%',
        str(round(monit.get('memory', 0) / 1024 / 1024, 1)) + 'mb',
        format_duration(env.get('pm_uptime')),
    ]
    print('\t'.join(row))
" | column -t -s $'\t'
}
