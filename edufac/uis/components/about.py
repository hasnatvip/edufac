from typing import Optional

import gradio

from edufac import metadata

METADATA_BUTTON : Optional[gradio.Button] = None


def render() -> None:
	global METADATA_BUTTON

	METADATA_BUTTON = gradio.Button(
		value = metadata.get('name'),
		variant = 'primary',
		link = metadata.get('url')
	)
