# Changelog

## 0.3.0

- Adds support for Rails 8

## 0.2.3

- Fixes miscased params and missing model param on event creation

## 0.2.2

- Sets published_at automatically when published changes
- Fixes showing unpublished versions in appcast

## 0.2.1

- Changes build to an integer so ordering works properly on every database
- Adds a lot of Sparkle 2.0 fields to the model

## 0.1.1

- Adds published boolean field to twinkle_versions and makes full validation conditional on being published
- Moves app functionality into a concern to be more easily extended by any utilizing apps

## 0.1.0

- Initial commit of Twinkle
