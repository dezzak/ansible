#!/usr/bin/env bash
find "$HOME/Downloads" -type f -mtime +30 -exec rm {} \;
