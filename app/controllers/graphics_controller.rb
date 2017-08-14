class GraphicsController < ApplicationController

  def hero
    width = params[:width] || 1920
    height = params[:height] || 496
    hero_common(width, height, 'blue', 'red')
  end

  def hero_gas
  end

  def hero_electric
  end

  def sample
    width = 200
    height = 200
    svg = Rasem::SVGImage.new(:width => width, :height => height) do
      # PATH example
      path("stroke" => "black") do
        moveToA(0, height / 2.0)
        vlineTo(height / 2.0 - 50)
        curveTo(50, 40, 0, 0, 50, 0)
        curveTo(-30, -50, 0, 0, 10, -30)
        vlineTo(-(height / 2.0 - 60))
      end

      # GROUP example
      defs do
        group(:id => "group1") do
          circle(0, 0, 20)
          text(0, 5, :fill => "red") { raw "hi!" }
        end
      end

      use("group1", :x => 100, :y => 25)
      use("group1", :x => 100, :y => 75, :fill => "blue")

      # GRADIENT example
      r1 = radialGradient("rgrad1") do
        stop("0%", "green", 1)
        stop("100%", "blue", 1)
      end

      r2 = radialGradient("rgrad2") do
        stop("0%", "yellow", 1)
        stop("100%", "red", 1)
      end

      r2 = radialGradient("rgrad2", {}, :skip) do
        stop("0%", "blue", 1)
        stop("100%", "red", 1)
      end

      r3 = linearGradient("lgrad1", {}, :skip) do
        stop("0%", "blue", 1)
        stop("100%", "red", 1)
      end

      circle(50, 25, 20, :fill => r1.fill)
      circle(50, 75, 20, :fill => r2.fill)
      circle(50, 125, 20, :fill => r3.fill)
    end
    respond_to do |format|
      format.svg { render inline: svg.to_s }
    end
  end

  private

    def hero_common(width, height, from, to)
      @svg = Rasem::SVGImage.new(width: width, height: height) do
        lr_gradient = linearGradient('lr-gradient', {}, :skip) do
          stop("0%", from, 1)
          stop("100%", to, 1)
        end

        defs do
          group(:id => "draw-gradient") do
            rectangle(x: 0, y: 0, width: width, height: height, stroke: 'none')
          end
        end
        use("draw-gradient", x: 0, y: 0, fill: lr_gradient.fill)

        origin = [0, (height - 0.235887*height).round]

        path("stroke" => "black") do
          moveToA(origin[0], origin[1])
          x, y = [(0.109375*width).round - origin[0], (height - 0.1532258*height).round - origin[1]]
          curveTo(x, y, 0, 0, 0, 0)
          x, y = [(0.677083*width).round - origin[0], (height - 0.5564516*height).round - origin[1]]
          curveTo(x, y, 0, 0, 0, 0)
        end
      end
      respond_to do |format|
        format.svg { render inline: @svg.to_s }
      end
    end
end
