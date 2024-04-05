local leap = require('leap')
leap.add_default_mappings()
leap.opts.case_sensitive = true
leap.opts.substitute_chars = { ['\r'] = '¬' }
leap.opts.special_keys.prev_target = '<s-enter>'
