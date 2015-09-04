About
===

There are a few good tools out there to get visual explain plans for Postgres. I need to make one that goes deeper into GPDB specific explain plans.

Installation
===

git clone https://github.com/skahler-pivotal/gpdbvisualizer.git
cd gpdbvisualizer
cf push <your_app_name> -b https://github.com/oetiker/sourcey-buildpack

Notes
===

Thanks
===

explain.depesz.com - Inspiration for much of this, over time ideally this will grow be as useful for GPDB as that is for Postgres
codepen.io - essential help for js hacking
bl.ocks.org/mbostock - all things D3 related
github.com/oetiker/sourcey-buildpack - Yay for perl buildpacks
mojolicio.us - Yay good perl stuffs
