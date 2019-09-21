#!/usr/bin/env bash
  
  flutter format --dry-run --set-exit-if-changed .
  flutter analyze
  flutter test --coverage test