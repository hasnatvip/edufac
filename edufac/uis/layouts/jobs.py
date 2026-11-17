import os

import gradio

from edufac import state_manager
from edufac.uis.components import about, job_list, job_list_options


def pre_check() -> bool:
	return True


def render() -> gradio.Blocks:
	with gradio.Blocks() as layout:
		with gradio.Row():
			with gradio.Column(scale = 4):
				with gradio.Blocks():
					about.render()
				with gradio.Blocks():
					job_list_options.render()
			with gradio.Column(scale = 11):
				with gradio.Blocks():
					job_list.render()
	return layout


def listen() -> None:
	job_list_options.listen()
	job_list.listen()


def run(ui : gradio.Blocks) -> None:
	share = os.getenv('GRADIO_SHARE', '0').lower() in [ '1', 'true' ]
	favicon_path = 'edufac.ico' if os.path.isfile('edufac.ico') else 'edufac.ico'
	ui.launch(favicon_path = favicon_path, inbrowser = state_manager.get_item('open_browser'), share = share)
