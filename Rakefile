task :default do
  FileUtils.rm_rf("dist")
  FileUtils.mkdir_p("dist")
  FileUtils.mkdir_p("dist/js")
  FileUtils.mkdir_p("dist/css")
  FileUtils.mkdir_p("dist/vendor")
  `coffee -c -o dist/js/ src/coffee/*.coffee`
  `coffee -c -o dist/ src/server.coffee`
  begin; FileUtils.cp "src/css/*.css", "dist/css/"; rescue; end
  begin; FileUtils.cp "src/index.html", "dist/index.html"; rescue; end
  begin; FileUtils.cp_r "src/vendor", "dist"; rescue; end
end