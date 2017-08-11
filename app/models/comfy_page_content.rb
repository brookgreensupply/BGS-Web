require 'textacular'
require 'nokogiri'

class ComfyPageContent < ActiveRecord::Base
  self.table_name = 'comfy_cms_blocks'

  default_scope {
    searchable = ['content', 'meta_description', 'main_banner']
    where(blockable_type: 'Comfy::Cms::Page').where('identifier IN (?)', searchable).joins \
      'INNER JOIN comfy_cms_pages p ON blockable_id = p.id AND is_published'
  }

  belongs_to :page, class_name: 'Comfy::Cms::Page', foreign_key: 'blockable_id'

  def self.search(string)
    results = advanced_search(string)
    tagged = results.map(&:page).reject { |p| Comfy::Cms::Categorization.where(categorized_id: p.id).empty? }
    slugs = tagged.map { |p| p.slug }.uniq
    most_recent_pages = slugs.map { |s|
      Comfy::Cms::Page.where('is_published').where(slug: s).order('created_at DESC').first
    }
    most_recent_pages.map { |p_id|
      where(blockable_id: p_id).where(identifier: 'content').order('updated_at DESC').first
    }
  end

  def self.searchable_language
    'english'
  end

  def self.searchable_columns
    ['content', 'meta_description']
  end

  def title
    page.label
  end

  def path
    "#{ComfortableMexicanSofa.config.public_cms_path}#{page.full_path}"
  end

  def to_text
    Nokogiri::HTML(content).text.gsub(/(\\r\\n|\n|\\)/, '')
  end
end
