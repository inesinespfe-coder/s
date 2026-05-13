#!/usr/bin/env python3
import sys
import json
import requests

# Configuration
alert_file = sys.argv[1]
ollama_url = "http://192.168.10.2:11434/api/generate"
slack_url = "https://hooksP.slack.com/services/T0B47K4VD7S/B0B3AP0U9EZ/toAU8TA7YR0Y5Va3Cdzwpk1U"

# Read Wazuh Alert
with open(alert_file) as f:
    alert_json = json.load(f)

description = alert_json.get('rule', {}).get('description', 'No description')
level = alert_json.get('rule', {}).get('level', 0)
agent = alert_json.get('agent', {}).get('name', 'Unknown')

# 1. Get AI Analysis from Ollama
prompt = f"Analyze this security alert and provide a 1-sentence summary: {description}. Level: {level}. Agent: {agent}."
payload = {"model": "llama3", "prompt": prompt, "stream": False}

try:
    ollama_res = requests.post(ollama_url, json=payload, timeout=45)
    ai_analysis = ollama_res.json().get('response', 'AI analysis unavailable.')
except Exception as e:
    ai_analysis = f"Ollama Error: {str(e)}"

# 2. Send Consolidated Alert to Slack
slack_data = {
    "text": f"🚨 *Wazuh + AI Alert*\n"
            f"*Rule:* {description} (Level {level})\n"
            f"*Agent:* {agent}\n"
            f"*AI Assessment:* {ai_analysis}"
}

requests.post(slack_url, json=slack_data)
