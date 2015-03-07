# Featherblade

*Jekyll plugin to shave off all that thick, unruly CSS*

## Usage

1. Add `gem 'featherblade'` to your site's Gemfile and run `bundle`
2. Add the following to your site's `_config.yml`:
```yml
gems:
  - featherblade
```
3. Use the liquid filter to show featherblade what to shave:
``` liquid
<style>{{ 'app.css' | asset | featherblade }}</style>
```

## Lather up and shave!
```bash
$ ./bin/jekyll serve --trace
Configuration file: /home/stevecrozz/Projects/personal/lithostech.com/_config.yml
Configuration file: /home/stevecrozz/Projects/personal/lithostech.com/_config.yml
Configuration file: /home/stevecrozz/Projects/personal/lithostech.com/_config.yml
            Source: /home/stevecrozz/Projects/personal/lithostech.com
       Destination: /home/stevecrozz/Projects/personal/lithostech.com/_site
 Incremental build: enabled
      Generating... 
Featherblade: shaved 18908 bytes (44.7%) from index.html 
Featherblade: shaved 21138 bytes (78.8%) from about-me/index.markdown 
Featherblade: shaved 19170 bytes (47.3%) from page/2/index.html 
Featherblade: shaved 19041 bytes (49.7%) from page/3/index.html 
Featherblade: shaved 19196 bytes (50.4%) from page/4/index.html 
Featherblade: shaved 19441 bytes (52.5%) from page/5/index.html 
Featherblade: shaved 19068 bytes (49.9%) from page/6/index.html 
Featherblade: shaved 19155 bytes (51.3%) from page/7/index.html 
Featherblade: shaved 19441 bytes (46.6%) from page/8/index.html 
Featherblade: shaved 19102 bytes (48.1%) from page/9/index.html 
Featherblade: shaved 19154 bytes (50.6%) from page/10/index.html 
Featherblade: shaved 19173 bytes (48.8%) from page/11/index.html 
Featherblade: shaved 18826 bytes (46.0%) from page/12/index.html 
Featherblade: shaved 19441 bytes (50.7%) from page/13/index.html 
Featherblade: shaved 19705 bytes (68.1%) from page/14/index.html 
                    done in 14.985 seconds.
 Auto-regeneration: enabled for '/home/stevecrozz/Projects/personal/lithostech.com'
Configuration file: /home/stevecrozz/Projects/personal/lithostech.com/_config.yml
    Server address: http://127.0.0.1:4000/
  Server running... press ctrl-c to stop.
```
