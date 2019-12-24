import traceback
from functools import partial

bind_to = 'app/Monitor/Bindings.hs'
bind_from = 'src/monitor.h'
template = 'scripts/template.txt'

# not all types - just the ones we use
types_map = {
    'unsigned long': 'CULong',
    'unsigned int': 'CUInt',
    'long': 'CLong',
    'int': 'CInt',
    'double': 'CDouble',
}

ff_template = 'foreign import ccall unsafe "monitor.h {function}" c_{function} :: IO {return_type}'
hs_template = '{function_hs} = {suffix} {prefix} c_{function}'

def to_camel_case(snake_str):
    components = snake_str.split('_')
    return components[0] + ''.join(x.title() for x in components[1:])


def c_to_hs(line):
    line_split = line.split('  // ')

    if len(line_split) == 2:
        line, params = line_split
        params = params.split(' | ')
        params[-1] = params[-1][:-1]  # drop '\n'

        if len(params) == 2:
            prefix, suffix = params
        else:
            prefix = params[0]
            suffix = ''
    else:
        line = line_split[0]
        prefix = ''
        suffix = ''

    line = line[:len(line)-3]  # drop '();'
    line_split = line.split(' ')
    
    function = line_split[-1]
    return_type = ' '.join(line_split[:-1])

    ff = ff_template.format(function=function, return_type=types_map[return_type])
    if suffix:
        suffix = f'({suffix})'
        if prefix:
            suffix += ' .'
    if prefix:
        prefix += ' <$>'

    hs = hs_template.format(
        function_hs=to_camel_case(function),
        prefix=prefix,
        function=function,
        suffix=suffix,
    )
    return ff, hs


def add_line(lines, line):
    lines.append(line + '\n')


def generate():
    bound_count = 0

    with open(template) as template_file:
        lines = template_file.readlines()
    append = partial(add_line, lines)
    
    with open(bind_from) as source:
        definitions = filter(lambda line: '();' in line, source.readlines())
    
    for definition in definitions:
        ff, hs = c_to_hs(definition)
        append(ff)
        append(hs)
        append('')
        bound_count += 1

    if bound_count > 0:
        lines = lines[:-1]

    return ''.join(lines), bound_count


if __name__ == '__main__':
    print(f"Generating bindings from '{bind_from}' to '{bind_to}'")
    try:
        result, bound_count = generate()
        with open(bind_to, mode='w') as target:
            target.truncate()
            print(result, file=target, end='')
    except Exception as e:
        print(f'Could not generate bindings - exception while building .hs file')
        traceback.print_exc()
        exit(1)
    print(f'Succesfully generated. Bound functions: {bound_count}')
    exit(0)
