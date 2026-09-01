js_code = <<~JS
  document.addEventListener('DOMContentLoaded', () => {
    const fixLinks = () => {
      document.querySelectorAll('a.powered-by-discourse, .powered-by-link a, a[href*="discourse.org/powered-by"]').forEach(a => {
        a.setAttribute('href', 'https://github.com/uongngocson');
        a.href = 'https://github.com/uongngocson';
      });
    };
    fixLinks();
    const observer = new MutationObserver(fixLinks);
    if (document.body) {
      observer.observe(document.body, { childList: true, subtree: true });
    }
    document.addEventListener('click', (e) => {
      const link = e.target.closest('a.powered-by-discourse, .powered-by-link a, a[href*="discourse.org/powered-by"]');
      if (link) {
        e.preventDefault();
        window.open('https://github.com/uongngocson', '_blank');
      }
    }, true);
  });
JS

Theme.all.each do |theme|
  field = theme.set_field(target: :common, name: :head_tag, value: "<script>#{js_code}</script>")
  theme.save!
  puts 'Injected into local theme: ' + theme.name.to_s
end
