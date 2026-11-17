from typing import Optional

METADATA =\
{
	'name': 'Edu',
	'description': 'Industry leading face manipulation platform',
	'version': '3.9.2',
	'license': 'OpenRAIL-AS',
	'author': 'Edu',
	'url': 'https://github.com/hasnatvip/edufac'
}


def get(key : str) -> Optional[str]:
	return METADATA.get(key)
