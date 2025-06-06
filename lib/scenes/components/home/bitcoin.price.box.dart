import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/constants/constants.dart';
import 'package:wallet/constants/proton.color.dart';
import 'package:wallet/constants/text.style.dart';
import 'package:wallet/helper/exchange.caculator.dart';
import 'package:wallet/helper/logger.dart';
import 'package:wallet/helper/user.settings.provider.dart';
import 'package:wallet/managers/providers/price.graph.data.provider.dart';
import 'package:wallet/rust/proton_api/exchange_rate.dart';
import 'package:wallet/rust/proton_api/price_graph.dart';
import 'package:wallet/scenes/components/bitcoin.price.chart.homepage.dart';
import 'package:wallet/scenes/components/bottom.sheets/bitcoin.price.detail.dart';
import 'package:wallet/scenes/components/custom.card_loading.builder.dart';

class BitcoinPriceBox extends StatefulWidget {
  final String title;
  final PriceGraphDataProvider priceGraphDataProvider;
  final ProtonExchangeRate exchangeRate;

  const BitcoinPriceBox({
    required this.title,
    required this.exchangeRate,
    required this.priceGraphDataProvider,
    super.key,
  });

  @override
  BitcoinPriceBoxState createState() => BitcoinPriceBoxState();
}

class BitcoinPriceBoxState extends State<BitcoinPriceBox> {
  bool initialized = false;

  double priceChange = 0.0;
  Timeframe timeFrame = Timeframe.oneDay;

  @override
  void didUpdateWidget(BitcoinPriceBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.exchangeRate.fiatCurrency !=
            widget.exchangeRate.fiatCurrency ||
        (oldWidget.exchangeRate.id == defaultExchangeRate.id &&
            widget.exchangeRate.id != defaultExchangeRate.id)) {
      fetchData();
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    if (widget.exchangeRate.id == defaultExchangeRate.id) {
      return;
    }
    PriceGraph? priceGraph;

    try {
      priceGraph = await widget.priceGraphDataProvider.getPriceGraph(
          fiatCurrency: widget.exchangeRate.fiatCurrency, timeFrame: timeFrame);
    } catch (e) {
      logger.d(e.toString());
    }
    final List<double> prices = [];
    if (priceGraph != null) {
      for (DataPoint dataPoint in priceGraph.graphData) {
        final double price = dataPoint.exchangeRate / widget.exchangeRate.cents;
        prices.add(price);
      }
    }

    if (mounted) {
      setState(() {
        initialized = true;
        if (prices.isNotEmpty) {
          priceChange = (prices.last - prices.first) / prices.first * 100;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: defaultPadding,
          vertical: 24,
        ),
        decoration: BoxDecoration(
          color: ProtonColors.backgroundSecondary,
          border: Border(
            top: BorderSide(
              color: ProtonColors.textHint,
              width: 0.2,
            ),
          ),
        ),
        child: SafeArea(
          child: GestureDetector(
            onTap: () {
              if (widget.exchangeRate.id != defaultExchangeRate.id ||
                  initialized) {
                BitcoinPriceDetailSheet.show(
                  context,
                  widget.exchangeRate,
                  widget.priceGraphDataProvider,
                );
              }
            },
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: ProtonStyles.body2Medium(
                          color: ProtonColors.textWeak,
                        ),
                      ),
                      (widget.exchangeRate.id == defaultExchangeRate.id &&
                              !initialized)
                          ? SizedBox(
                              width: 160,
                              child: CustomCardLoadingBuilder(
                                height: 16,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                margin: EdgeInsets.only(top: 4),
                              ).build(context),
                            )
                          : Align(
                              alignment: Alignment.centerLeft,
                              child: Wrap(children: [
                                AnimatedFlipCounter(
                                    duration: const Duration(milliseconds: 500),
                                    prefix: Provider.of<UserSettingProvider>(
                                            context)
                                        .getFiatCurrencySign(
                                            fiatCurrency: widget
                                                .exchangeRate.fiatCurrency),
                                    thousandSeparator: ",",
                                    value: ExchangeCalculator
                                        .getNotionalInFiatCurrency(
                                            widget.exchangeRate, btc2satoshi),
                                    // value: price,
                                    fractionDigits:
                                        ExchangeCalculator.getDisplayDigit(
                                            widget.exchangeRate),
                                    textStyle: ProtonStyles.body2Medium(
                                        color: ProtonColors.textNorm)),
                                const SizedBox(
                                  width: 8,
                                ),
                                priceChange > 0
                                    ? AnimatedFlipCounter(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        prefix: "+",
                                        value: priceChange,
                                        suffix: "% (1d)",
                                        fractionDigits: 2,
                                        textStyle: ProtonStyles.body2Medium(
                                            color: ProtonColors
                                                .notificationSuccess))
                                    : AnimatedFlipCounter(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        prefix: "",
                                        value: priceChange,
                                        suffix: "% (1d)",
                                        fractionDigits: 2,
                                        textStyle: ProtonStyles.body2Medium(
                                            color: ProtonColors
                                                .notificationError)),
                              ]),
                            )
                    ],
                  ),
                  if (widget.exchangeRate.id != defaultExchangeRate.id ||
                      initialized)
                    Expanded(
                      child: BitcoinPriceHomepageChart(
                        exchangeRate: widget.exchangeRate,
                        priceGraphDataProvider: widget.priceGraphDataProvider,
                        priceChange: priceChange,
                      ),
                    ),
                ]),
          ),
        ),
      ),
    );
  }
}
