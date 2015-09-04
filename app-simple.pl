#!/usr/bin/env perl
use Mojolicious::Lite;
use GP::Explain;
use JSON;

get '/' => sub {
  my $self = shift;
  $self->render('index');
};

put '/querysubmit' => sub {
  my $self = shift;
  my $value = $self->param('query');
  my $explain = GP::Explain->new( source => $value);
  $explain->parse_source;
  my $got = $explain->top_node->get_struct();
  my $json_text = to_json( $got, { ascii => 1, pretty => 1 } );
  $json_text =~  s/sub_nodes/children/g;
  $self->stash(json_text => $json_text);
  $self->render('explain');
};


app->start;
__DATA__

@@ index.html.ep
% layout 'default';
% title 'GPDB Query Visualizer';

<div>
Submit your query 
%= form_for querysubmit => (method => 'POST') => begin
  <textarea name="query" cols=120 rows=20>
                                                QUERY PLAN
 ----------------------------------------------------------------------------------------------------------
Limit  (cost=152119451.35..152119453.60 rows=100 width=498)
  Rows out:  29 rows with 185540 ms to end, start offset by 1446 ms.
  ->  Gather Motion 64:1  (slice5; segments: 64)  (cost=152119451.35..152119453.60 rows=100 width=498)
        Merge Key: partial_aggregation.i_item_id
        Rows out:  29 rows at destination with 185540 ms to end, start offset by 1446 ms.
        ->  Limit  (cost=152119451.35..152119451.60 rows=2 width=498)
              Rows out:  Avg 1.3 rows x 23 workers.  Max 3 rows (seg46) with 185520 ms to end, start offset by 1465 ms.
              ->  Sort  (cost=152119451.35..152119451.70 rows=3 width=498)
                    Sort Key (Limit): partial_aggregation.i_item_id
                    Rows out:  Avg 1.3 rows x 23 workers.  Max 3 rows (seg46) with 185520 ms to end, start offset by 1465 ms.
                    Executor memory:  58K bytes avg, 58K bytes max (seg0).
                    Work_mem used:  58K bytes avg, 58K bytes max (seg0). Workfile: (0 spilling, 0 reused)
                    ->  HashAggregate  (cost=152119445.01..152119446.40 rows=3 width=498)
                          Group By: item.i_item_id, item.i_item_desc, item.i_current_price
                          Rows out:  Avg 1.3 rows x 23 workers.  Max 3 rows (seg46) with 185519 ms to end, start offset by 1465 ms.
                          Executor memory:  554K bytes avg, 601K bytes max (seg2).
                          ->  Redistribute Motion 64:64  (slice4; segments: 64)  (cost=152119439.80..152119442.58 rows=3 width=498)
                                Hash Key: item.i_item_id, item.i_item_desc, item.i_current_price
                                Rows out:  Avg 80.7 rows x 23 workers at destination.  Max 192 rows (seg46) with 143778 ms to first row, 185518 ms to end, start offset by 1466 ms.
                                ->  HashAggregate  (cost=152119439.80..152119439.80 rows=3 width=498)
                                      Group By: item.i_item_id, item.i_item_desc, item.i_current_price
                                      Rows out:  Avg 29.0 rows x 64 workers.  Max 29 rows (seg0) with 183712 ms to first row, 183713 ms to end, start offset by 1464 ms.
                                      Executor memory:  601K bytes avg, 601K bytes max (seg0).
                                      ->  Hash Join  (cost=16965353.31..152080569.26 rows=80981 width=127)
                                            Hash Cond: store_sales.ss_item_sk = item.i_item_sk
                                            Rows out:  Avg 846927.2 rows x 64 workers.  Max 864539 rows (seg18) with 7883 ms to first row, 145924 ms to end, start offset by 1478 ms.
                                            Executor memory:  407K bytes avg, 407K bytes max (seg0).
                                            Work_mem used:  407K bytes avg, 407K bytes max (seg0). Workfile: (0 spilling, 0 reused)
                                            (seg18)  Hash chain length 74.3 avg, 88 max, using 29 of 32779 buckets.
                                            ->  Append-only Scan on store_sales  (cost=0.00..112634309.12 rows=134999008 width=4)
                                                  Rows out:  Avg 134999001.3 rows x 64 workers.  Max 135028019 rows (seg31) with 46 ms to first row, 120497 ms to end, start offset by 9332 ms.
                                            ->  Hash  (cost=16965180.50..16965180.50 rows=217 width=135)
                                                  Rows in:  Avg 2156.0 rows x 64 workers.  Max 2156 rows (seg0) with 7865 ms to end, start offset by 1465 ms.
                                                  ->  Broadcast Motion 64:64  (slice3; segments: 64)  (cost=14878.40..16965180.50 rows=217 width=135)
                                                        Rows out:  Avg 2156.0 rows x 64 workers at destination.  Max 2156 rows (seg0) with 2389 ms to first row, 7864 ms to end, start offset by 1465 ms.
                                                        ->  Hash Join  (cost=14878.40..16965040.10 rows=4 width=135)
                                                              Hash Cond: inventory.inv_item_sk = item.i_item_sk
                                                              Rows out:  Avg 86.2 rows x 25 workers.  Max 156 rows (seg10) with 1187 ms to first row, 7855 ms to end, start offset by 1468 ms.
                                                              Executor memory:  1K bytes avg, 1K bytes max (seg0).
                                                              Work_mem used:  1K bytes avg, 1K bytes max (seg0). Workfile: (0 spilling, 0 reused)
                                                              (seg0)   Hash chain length 1.0 avg, 1 max, using 4 of 32779 buckets.
                                                              (seg10)  Hash chain length 1.0 avg, 1 max, using 2 of 32779 buckets.
                                                              ->  Redistribute Motion 64:64  (slice2; segments: 64)  (cost=1563.30..16950938.63 rows=4898 width=4)
                                                                    Hash Key: inventory.inv_item_sk
                                                                    Rows out:  Avg 211976.4 rows x 38 workers at destination.  Max 213878 rows (seg40) with 1066 ms to first row, 7817 ms to end, start offset by 1474 ms.
                                                                    ->  Hash Join  (cost=1563.30..16944669.30 rows=4898 width=4)
                                                                          Hash Cond: inventory.inv_date_sk = date_dim.d_date_sk
                                                                          Rows out:  Avg 211959.1 rows x 64 workers.  Max 212543 rows (seg39) with 20 ms to first row, 5693 ms to end, start offset by 1470 ms.
                                                                          Executor memory:  2K bytes avg, 2K bytes max (seg0).
                                                                          Work_mem used:  2K bytes avg, 2K bytes max (seg0). Workfile: (0 spilling, 0 reused)
                                                                          (seg39)  Hash chain length 1.0 avg, 1 max, using 61 of 262151 buckets.
                                                                          ->  Append-only Scan on inventory  (cost=0.00..15896520.00 rows=6208105 width=8)
                                                                                Filter: inv_quantity_on_hand >= 100 AND inv_quantity_on_hand <= 500
                                                                                Rows out:  Avg 6146192.9 rows x 64 workers.  Max 6150462 rows (seg25) with 40 ms to first row, 4789 ms to end, start offset by 1483 ms.
                                                                          ->  Hash  (cost=1517.20..1517.20 rows=58 width=4)
                                                                                Rows in:  Avg 61.0 rows x 64 workers.  Max 61 rows (seg0) with 16 ms to end, start offset by 1467 ms.
                                                                                ->  Broadcast Motion 64:64  (slice1; segments: 64)  (cost=0.00..1517.20 rows=58 width=4)
                                                                                      Rows out:  Avg 61.0 rows x 64 workers at destination.  Max 61 rows (seg0) with 0.038 ms to first row, 16 ms to end, start offset by 1467 ms.
                                                                                      ->  Seq Scan on date_dim  (cost=0.00..1479.73 rows=1 width=4)
                                                                                            Filter: d_date >= '2002-05-30'::date AND d_date <= '2002-07-29'::date
                                                                                            Rows out:  Avg 1.1 rows x 55 workers.  Max 2 rows (seg2) with 0.202 ms to first row, 0.408 ms to end, start offset by 1469 ms.
                                                              ->  Hash  (cost=13312.00..13312.00 rows=4 width=131)
                                                                    Rows in:  Avg 1.4 rows x 38 workers.  Max 4 rows (seg0) with 4.463 ms to end, start offset by 1465 ms.
                                                                    ->  Seq Scan on item  (cost=0.00..13312.00 rows=4 width=131)
                                                                          Filter: i_current_price >= 30::numeric AND i_current_price <= 60::numeric AND (i_manufact_id = ANY ('{437,129,727,663}'::integer[]))
                                                                          Rows out:  Avg 1.4 rows x 38 workers.  Max 4 rows (seg0) with 0.554 ms to first row, 4.427 ms to end, start offset by 1465 ms.
Slice statistics:
  (slice0)    Executor memory: 494K bytes.
  (slice1)    Executor memory: 959K bytes avg x 64 workers, 959K bytes max (seg0).
  (slice2)    Executor memory: 5339K bytes avg x 64 workers, 5380K bytes max (seg26).  Work_mem: 2K bytes max.
  (slice3)    Executor memory: 1743K bytes avg x 64 workers, 2132K bytes max (seg0).  Work_mem: 1K bytes max.
  (slice4)    Executor memory: 3452K bytes avg x 64 workers, 3458K bytes max (seg2).  Work_mem: 407K bytes max.
  (slice5)    Executor memory: 1000K bytes avg x 64 workers, 1061K bytes max (seg2).  Work_mem: 58K bytes max.
Statement statistics:
  Memory used: 128000K bytes
Total runtime: 186986.509 ms
  </textarea>
</div>
<div>
  %= submit_button 'Visualize'
</div>
% end

@@ explain.html.ep
% layout 'default';
% title 'GPDB Query Visualizer';

<div id="body">
<div>
    <button onclick="expandAll()">Expand All</button>
    <button onclick="collapseAll()">Collapse All</button>
</div>
</div>

<script src="http://d3js.org/d3.v3.min.js" charset="utf-8"></script>
<script>

var margin = {
    top: 10,
    right: 10,
    bottom: 10,
    left: 10
  },
  width = 3000 - margin.right - margin.left,
  height = 3000 - margin.top - margin.bottom;

var root = <%== $json_text %>;

var i = 0,
  duration = 750,
  rectW = 180,
  rectH = 120;

var tree = d3.layout.tree().nodeSize([200, 140]);
var diagonal = d3.svg.diagonal()
  .projection(function(d) {
    return [d.x + rectW / 2, d.y + rectH / 2];
  });

var svg = d3.select("#body").append("svg").attr("width", 4000).attr("height", 4000)
  .call(zm = d3.behavior.zoom().scaleExtent([0, 2]).on("zoom", redraw)).append("g")
  .attr("transform", "translate(" + 350 + "," + 20 + ")");

//necessary so that zoom knows where to zoom and unzoom from
zm.translate([350, 20]);

root.x0 = 0;
root.y0 = height / 2;

function collapse(d) {
  if (d.children) {
    d._children = d.children;
    d._children.forEach(collapse);
    d.children = null;
  }
}

root.children.forEach(collapse);
update(root);

d3.select("#body").style("height", "800px");

function update(source) {

  // Compute the new tree layout.
  var nodes = tree.nodes(root).reverse(),
    links = tree.links(nodes);

  // Normalize for fixed-depth.
  nodes.forEach(function(d) {
    d.y = d.depth * 160;
  });

  // Update the nodes…
  var node = svg.selectAll("g.node")
    .data(nodes, function(d) {
      return d.id || (d.id = ++i);
    });

  // Enter any new nodes at the parent's previous position.
  var nodeEnter = node.enter().append("g")
    .attr("class", "node")
    .attr("transform", function(d) {
      return "translate(" + source.x0 + "," + source.y0 + ")";
    })
    .on("click", click);

  nodeEnter.append("rect")
    .attr("width", rectW)
    .attr("height", rectH)
    .attr("stroke", "black")
    .attr("stroke-width", 0)
    .style("fill", function(d) {
      return d._children ? "lightsteelblue" : "#fff";
    });

  nodeEnter.append("text")
    .attr("x", rectW / 2)
    .attr("y", rectH / 2)
    .attr("dy", ".35em")
    .attr("text-anchor", "middle")
    .attr("font-weight", "bold")
    .attr("font-size", 14)
    .text(function(d) {
      return d.type;
    });

    nodeEnter.append("text")
    .attr("x", rectW / 2)
    .attr("y", rectH / 2 + 15)
    .attr("dy", ".35em")
    .attr("text-anchor", "middle")
    .attr("font-size", 14)
    .text(function(d) {
      return "Cost: " + d.estimated_total_cost;
    });

  nodeEnter.append("text")
    .attr("x", 5)
    .attr("y", 5)
    .attr("dy", "1em")
    .attr("text-anchor", "left")
    .attr("font-size", 12)
    .attr("fill", "red")
    .text(function(d) {
      return d.slice ? "slice" + d.slice : "";
    });

  nodeEnter.append("text")
    .attr("x", rectW / 2)
    .attr("y", 5)
    .attr("dy", "1em")
    .attr("text-anchor", "middle")
    .attr("font-size", 12)
    .attr("font-weight", "bold")
    .attr("fill", "blue")
    .text(function(d) {
      return d.table_name ? d.table_name : "";
    });

  nodeEnter.append("text")
    .attr("x", rectW / 2)
    .attr("y", -15)
    .attr("dy", "1em")
    .attr("font-size", 10)
    .text( function(d) { return d.filter ? "Filter: " + d.filter : ""; } )
    /* .call(wrap, 300) */
    .attr("text-anchor", "middle")
    ;

  nodeEnter.append("text")
    .attr("x", rectW / 2)
    .attr("y", -15)
    .attr("dy", "1em")
    .attr("font-size", 10)
    .text( function(d) { return d.group_by ? "Filter: " + d.group_by : ""; } )
    /* .call(wrap, 300) */
    .attr("text-anchor", "middle")
    ;

  nodeEnter.append("text")
    .attr("x", rectW / 2)
    .attr("y", -15)
    .attr("dy", "1em")
    .attr("text-anchor", "middle")
    .attr("font-size", 10)
    .text(function(d) {
      return d.hash_condition ? "Hash Condition: " + d.hash_condition : "";
    });

  nodeEnter.append("text")
    .attr("x", rectW / 2)
    .attr("y", -15)
    .attr("dy", "1em")
    .attr("text-anchor", "middle")
    .attr("font-size", 10)
    .text(function(d) {
      return d.sort_key_limit ? "Sort Key Limit: " + d.sort_key_limit : "";
    });

  nodeEnter.append("text")
    .attr("x", rectW / 2)
    .attr("y", -15)
    .attr("dy", "1em")
    .attr("text-anchor", "middle")
    .attr("font-size", 10)
    .text(function(d) {
      return d.merge_key ? "Merge Key: " + d.merge_key : "";
    });

    nodeEnter.append("text")
    .attr("x", rectW - 5 )
    .attr("y", rectH - 25 )
    .attr("dy", "1em")
    .attr("text-anchor", "end")
    .attr("font-size", 10)
    .text(function(d) {
      return ( d.source_segments ? d.source_segments + "->" : "" ) + ( d.destination_segments ? d.destination_segments : "" );
    });

    nodeEnter.append("text")
    .attr("x", rectW - 5 )
    .attr("y", rectH - 15 )
    .attr("dy", "1em")
    .attr("text-anchor", "end")
    .attr("font-size", 10)
    .text(function(d) {
      return ( d.rows_out_workers ? "Workers: " + d.rows_out_workers : "" ) + ( d.rows_in_workers ? "Workers: " + d.rows_in_workers : "" );
    });

  nodeEnter.append("text")
    .attr("x", 5)
    .attr("y", rectH - 25)
    .attr("dy", "1em")
    .attr("text-anchor", "start")
    .attr("font-size", 10)
    .text(function(d) {
      return d.rows_out_count ? "Rows: " + d.rows_out_count : "";
    });

  nodeEnter.append("text")
    .attr("x", 5)
    .attr("y", rectH - 35)
    .attr("dy", "1em")
    .attr("text-anchor", "start")
    .attr("font-size", 10)
    .text(function(d) {
      return d.rows_out_avg_rows ? "Avg Rows: " + d.rows_out_avg_rows : "";
    });

  nodeEnter.append("text")
    .attr("x", 5)
    .attr("y", rectH - 25)
    .attr("dy", "1em")
    .attr("text-anchor", "start")
    .attr("font-size", 10)
    .text(function(d) {
      return d.rows_out_max_rows ? "Max Rows: " + d.rows_out_max_rows + " (" + d.rows_out_max_rows_segment + ")" : "";
    });

  nodeEnter.append("text")
    .attr("x", 5)
    .attr("y", rectH - 35)
    .attr("dy", "1em")
    .attr("text-anchor", "start")
    .attr("font-size", 10)
    .text(function(d) {
      return d.rows_in_avg_rows ? "Avg Rows: " + d.rows_in_avg_rows : "";
    });

  nodeEnter.append("text")
    .attr("x", 5)
    .attr("y", rectH - 25)
    .attr("dy", "1em")
    .attr("text-anchor", "start")
    .attr("font-size", 10)
    .text(function(d) {
      return d.rows_in_max_rows ? "Max Rows: " + d.rows_in_max_rows + " (" + d.rows_in_max_rows_segment + ")" : "";
    });

  nodeEnter.append("text")
    .attr("x", 5)
    .attr("y", rectH - 15)
    .attr("dy", "1em")
    .attr("text-anchor", "start")
    .attr("font-size", 10)
    .text(function(d) {
      return d.estimated_rows ? "Est Rows: " + d.estimated_rows : "";
    });

  nodeEnter.append("text")
    .attr("x", rectW / 2)
    .attr("y", rectH)
    .attr("dy", "1em")
    .attr("text-anchor", "middle")
    .attr("font-size", 10)
    .text(function(d) {
      return (d.rows_out_offset ? "Offset: " + d.rows_out_offset : "") + " " + (d.rows_out_ms_to_first_row ? "First: " + d.rows_out_ms_to_first_row : "") + " " + (d.rows_out_ms_to_end ? "End: " + d.rows_out_ms_to_end : "");
    });

  // Transition nodes to their new position.
  var nodeUpdate = node.transition()
    .duration(duration)
    .attr("transform", function(d) {
      return "translate(" + d.x + "," + d.y + ")";
    });

  nodeUpdate.select("rect")
    .attr("width", rectW)
    .attr("height", rectH)
    .attr("stroke", "black")
    .attr("stroke-width", 1)
    .style("fill", function(d) {
      return d._children ? "lightsteelblue" : "#fff";
    });

  nodeUpdate.select("text")
    .style("fill-opacity", 1);

  // Transition exiting nodes to the parent's new position.
  var nodeExit = node.exit().transition()
    .duration(duration)
    .attr("transform", function(d) {
      return "translate(" + source.x + "," + source.y + ")";
    })
    .remove();

  nodeExit.select("rect")
    .attr("width", rectW)
    .attr("height", rectH)
    //.attr("width", bbox.getBBox().width)""
    //.attr("height", bbox.getBBox().height)
    .attr("stroke", "black")
    .attr("stroke-width", 1);

  nodeExit.select("text");

  // Update the links…
  var link = svg.selectAll("path.link")
    .data(links, function(d) {
      return d.target.id;
    });

  // Enter any new links at the parent's previous position.
  link.enter().insert("path", "g")
    .attr("class", "link")
    .attr("x", rectW / 2)
    .attr("y", rectH / 2)
    .attr("d", function(d) {
      var o = {
        x: source.x0,
        y: source.y0
      };
      return diagonal({
        source: o,
        target: o
      });
    });

  // Transition links to their new position.
  link.transition()
    .duration(duration)
    .attr("d", diagonal);

  // Transition exiting nodes to the parent's new position.
  link.exit().transition()
    .duration(duration)
    .attr("d", function(d) {
      var o = {
        x: source.x,
        y: source.y
      };
      return diagonal({
        source: o,
        target: o
      });
    })
    .remove();

  // Stash the old positions for transition.
  nodes.forEach(function(d) {
    d.x0 = d.x;
    d.y0 = d.y;
  });
}

// Toggle children on click.
function click(d) {
  if (d.children) {
    d._children = d.children;
    d.children = null;
  } else {
    d.children = d._children;
    d._children = null;
  }
  update(d);
}

//Redraw for zoom
function redraw() {
  //console.log("here", d3.event.translate, d3.event.scale);
  svg.attr("transform",
    "translate(" + d3.event.translate + ")" + " scale(" + d3.event.scale + ")");
}

//Expand the entire tree function
function expandAll(){
    expand(root); 
    update(root);
}

//Collapse the entire tree function
function collapseAll(){
    root.children.forEach(collapse);
    collapse(root);
    update(root);
}

//Expand a node and each of it's children
function expand(d){   
    var children = (d.children)?d.children:d._children;
    if (d._children) {        
        d.children = d._children;
        d._children = null;       
    }
    if(children)
      children.forEach(expand);
}

function wrap(text, width) {
  text.each(function() {
    var text = d3.select(this),
        words = text.text().split(/\s+/).reverse(),
        word,
        line = [],
        lineNumber = 0,
        lineHeight = 1.1, // ems
        y = text.attr("y"),
        dy = parseFloat(text.attr("dy")),
        tspan = text.text(null).append("tspan").attr("x", 0).attr("y", y).attr("dy", dy + "em");
    while (word = words.pop()) {
      line.push(word);
      tspan.text(line.join(" "));
      if (tspan.node().getComputedTextLength() > width) {
        line.pop();
        tspan.text(line.join(" "));
        line = [word];
        tspan = text.append("tspan").attr("x", 0).attr("y", y).attr("dy", ++lineNumber * lineHeight + dy + "em").text(word);
      }
    }
  });
}

</script>

@@ layouts/default.html.ep
<!DOCTYPE html>
<html>
  <head><title><%= title %></title></head>
<style>
.hint { color: #aaaaaa; }
.node { cursor: pointer; }
.node circle { fill: #fff; stroke: steelblue; stroke-width: 1.5px; }
.node text { font: sans-serif; }
.link { fill: none; stroke: #ccc; stroke-width: 1.5px; }
body { overflow: hidden; }
</style>

<h1>GPDB Query Visualizer</h1>
  <body><%= content %></body>
</html>
