engine = require('ejs');
fs = require('fs');

# valid hostnames
hostnames = require('./hostnames.json');

images = fs.readdirSync(__dirname + "/web/images").filter((x) -> x!=".DS_Store").sort();
htaccess = "RewriteEngine On \n\n";

for hostname, i in hostnames
	# write html file
	fs.writeFileSync(
		__dirname + "/web/" + hostname + ".html", 
		engine.render(fs.readFileSync('template/index.html.ejs', {encoding: 'UTF8' }),{hostname: hostname, image: images[i]})
	);

	# add rule to htacces
	htaccess += "# " + hostname + "\n"
	htaccess += "RewriteCond %{HTTP_HOST} " + hostname + " [NC] \n"
	htaccess += "RewriteRule ^$ " + hostname + ".html [L] \n\n"

# write htaccess
fs.writeFileSync(__dirname + "/web/.htaccess", htaccess);