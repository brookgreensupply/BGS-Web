require 'flipper/adapters/active_record'
adapter = Flipper::Adapters::ActiveRecord.new
FF = Flipper.new(adapter)

begin
  allowed = [:email, :cma]
  Flipper::Adapters::ActiveRecord::Feature.all.each do |f|
    if !allowed.include?(f.key.to_sym)
      puts "Disabling and deleting unknown feature :#{f.key}..."
      FF[f.key].disable
      f.destroy
    end
  end
  allowed.each { |key| FF[key].disable if !FF[key].enabled? }
rescue
end
