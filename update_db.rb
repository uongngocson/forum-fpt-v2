puts "Updating TranslationOverrides..."
['en', 'vi'].each do |loc|
  begin
    TranslationOverride.upsert!(loc, 'powered_by_discourse', 'Powered by UNS')
    TranslationOverride.upsert!(loc, 'powered_by_html', 'Powered by <a href="https://github.com/uongngocson">UNS</a>')
    TranslationOverride.upsert!(loc, 'js.powered_by_discourse', 'Powered by UNS')
  rescue => e
    puts "Error on translation #{loc}: #{e.message}"
  end
end

puts "Updating Posts containing GitHub links..."
Post.all.each do |p|
  changed = false
  new_raw = p.raw.dup
  if new_raw.include?('github.com') && !new_raw.include?('github.com/uongngocson')
    new_raw = new_raw.gsub(/https:\/\/github\.com\/[^\s\)\>\"\]]+/, 'https://github.com/uongngocson')
    changed = true
  end
  if new_raw.include?('discourse.org')
    new_raw = new_raw.gsub(/https?:\/\/(?:www\.)?discourse\.org[^\s\)\>\"\]]*/, 'https://github.com/uongngocson')
    changed = true
  end
  if changed
    puts "Updating Post #{p.id}"
    p.raw = new_raw
    p.cook(new_raw)
    p.update_columns(raw: new_raw, cooked: p.cooked)
  end
end

puts "All database overrides and links updated successfully!"
