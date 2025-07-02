import re
import subprocess
import requests
import json
import os

WEBHOOK_URL = "https://n8n.mydomain.com/webhook-test/apache-error"

def get_git_blame(file_path, line_number):
    try:
        # Find git repo root
        repo_path = subprocess.check_output(
            ["git", "rev-parse", "--show-toplevel"],
            cwd=os.path.dirname(file_path),
            text=True
        ).strip()

        # Get relative file path inside repo
        rel_path = os.path.relpath(file_path, repo_path)

        # Run blame
        blame_output = subprocess.check_output(
            ["git", "blame", "-L", f"{line_number},{line_number}", "--porcelain", rel_path],
            cwd=repo_path,
            text=True
        )

        # Parse blame output
        blame = {
            "author": None,
            "email": None,
            "commit": None,
            "summary": None
        }

        for line in blame_output.splitlines():
            if line.startswith("author "):
                blame["author"] = line[7:]
            elif line.startswith("author-mail "):
                blame["email"] = line[12:].strip("<>")
            elif line.startswith("summary "):
                blame["summary"] = line[8:]
            elif re.match(r"^[a-f0-9]{40}", line):
                blame["commit"] = line.split()[0][:8]

        return blame

    except subprocess.CalledProcessError as e:
        print(f"[blame error] {e}")
        return None

def get_project_info(error_line):
    match = re.search(r'in (.+?) on line (\d+)', error_line)
    if not match:
        return None

    file_path, line_number = match.groups()
    file_path = file_path.strip()
    line_number = int(line_number)

    # Apache vhost (assuming standard structure)
    vhost = subprocess.getoutput(f"grep -l '{file_path}' /etc/apache2/sites-enabled/* || true")

    # Git remote
    git_remote = subprocess.getoutput(
        f"cd $(dirname '{file_path}') && git config --get remote.origin.url || echo 'unknown'"
    )

    # Git blame details
    blame = get_git_blame(file_path, line_number)

    payload = {
        "file": file_path,
        "line": line_number,
        "vhost": vhost.strip(),
        "git_remote": git_remote.strip(),
        "error_line": error_line.strip(),
        "blame": blame
    }

    return payload

def send_to_n8n(payload):
    try:
        response = requests.post(WEBHOOK_URL, json=payload, timeout=5)
        print(f"Sent to n8n: {response.status_code}")
    except Exception as e:
        print(f"Failed to send to n8n: {e}")

def tail_and_watch(log_file):
    with open(log_file, "r") as f:
        f.seek(0, 2)  # Move to end of file
        while True:
            line = f.readline()
            if not line:
                continue
            if "PHP" in line or "error" in line.lower():
                payload = get_project_info(line)
                if payload:
                    send_to_n8n(payload)

# Start watching the log
tail_and_watch("/var/log/apache2/error.log")
