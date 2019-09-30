#!/usr/bin/env python3 

from jinja2 import *
import os

def info(string):
    print("[ \033[32m+\033[0m ] {}".format(string))

def error(string):
    print("[ \033[31m!\033[0m ] {}".format(string))

def test_basic_functions():
    #name = raw_input("Input your name:")
    name = "Template Object"
    tm = Template("{{ name }}")
    msg = tm.render(name=name)
    info("Template Object: {}".format(msg))

def test_array_dictionary():
    person = {'name':'me', 'age':4}
    tm = Template("{{ person.name}} & {{ person.age }}")
    msg = tm.render(person=person)
    info("Array Dictionary: {}".format(msg))

def test_raw_endraw():
    name = "Template Object"
    data = """
    {% raw %}
    BLOCK raw-endraw {{ name }}
    {% endraw %}
    """
    tm = Template(data)
    msg = tm.render(name=name)
    print(msg)

def test_escape():
    data = """
    <a>Today is a sunny day</a>
    """
    tm = Template("{{ data | e}}")
    msg = tm.render(data=data)
    print(msg)
    print(escape(data))

def test_html():
    HTML = """
    <html>
    <head>
    <title>{{ title }}</title>
    </head>
    <body>
    xx.
    </body>
    </html>
    """
    print Environment().from_string(HTML).render(title="test_html")

def test_file_system_loader():
    '''
    generate test_template.html
    <html>
    <head>
    <title>{{ title }}</title>
    </head>
    <body>
    xx.
    </body>
    </html>
    '''

    CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
    print Environment(loader=FileSystemLoader(CURRENT_DIR), trim_blocks=True).get_template('test_template.html').render(title="test_file_system_loader")

def main():
    test_basic_functions()
    test_array_dictionary()
    test_raw_endraw()
    test_escape()
    test_html()
    test_file_system_loader()

if __name__ == "__main__":
    try:
        main()
    except (KeyboardInterrupt, SystemExit):
        pass
