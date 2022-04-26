#include <app/SvgScrew.hpp>
#include <settings.hpp>

namespace rack {
namespace app {


SvgScrew::SvgScrew() {
	fb = new widget::FramebufferWidget;
	addChild(fb);

	sw = new widget::SvgWidget;
	fb->addChild(sw);
}


void SvgScrew::setSvg(std::shared_ptr<window::Svg> svg) {
	sw->setSvg(svg);
	fb->box.size = sw->box.size;
	box.size = sw->box.size;
}

void SvgScrew::draw(const DrawArgs& args) {
	if (!settings::skeuomorphic)
		return;

	// Child widgets
	Widget::draw(args);
}


} // namespace app
} // namespace rack
