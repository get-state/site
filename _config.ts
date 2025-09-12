import lume from "lume/mod.ts";
import blog from "blog/mod.ts";

const site = lume(
	{
	    location: new URL("https://get-state.github.io/site/"),
	}
);

site.use(blog());

export default site;
