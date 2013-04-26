def formatter(config, event):
    '''
    desc is the entire desc, with '\n' replaced with '  '. this output doesn't attempt to shorten the desc string.
    '''
    recommended_tags = set([t[0] for t in config.recommended_tags])
    desc = event['desc'].replace('\n', '  ')
    expected_result = event.get('expected_result', '')
    characterizing_tags = set(event['tags']).intersection(recommended_tags)
    for k in characterizing_tags:
        if k in config.engineering_tags:
            characterizing_tags.remove(k)
            characterizing_tags.add('engineering')
    if not characterizing_tags:
        return None
    category = '-'.join(sorted(characterizing_tags))
    tags = ' '.join(sorted(set(event['tags']).difference(characterizing_tags)))
    return [str(event['date']), desc, tags, category, expected_result]
