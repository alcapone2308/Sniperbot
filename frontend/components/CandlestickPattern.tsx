import React from 'react';
import { View, StyleSheet } from 'react-native';
import Svg, { Rect, Line } from 'react-native-svg';

interface CandlestickPatternProps {
  size?: number;
  type?: 'bullish' | 'bearish' | 'doji';
  animated?: boolean;
}

export const CandlestickPattern: React.FC<CandlestickPatternProps> = ({
  size = 60,
  type = 'bullish',
  animated = false,
}) => {
  const getColor = () => {
    switch (type) {
      case 'bullish':
        return '#10B981';
      case 'bearish':
        return '#EF4444';
      case 'doji':
        return '#F59E0B';
      default:
        return '#10B981';
    }
  };

  const color = getColor();
  const width = size;
  const height = size * 1.5;

  return (
    <View style={[styles.container, { width, height }]}>
      <Svg width={width} height={height} viewBox={`0 0 ${width} ${height}`}>
        {/* Candlestick body and wicks */}
        {type === 'bullish' && (
          <>
            {/* Upper wick */}
            <Line
              x1={width / 2}
              y1={height * 0.1}
              x2={width / 2}
              y2={height * 0.3}
              stroke={color}
              strokeWidth="2"
            />
            {/* Body */}
            <Rect
              x={width * 0.25}
              y={height * 0.3}
              width={width * 0.5}
              height={height * 0.45}
              fill={color}
              rx="2"
            />
            {/* Lower wick */}
            <Line
              x1={width / 2}
              y1={height * 0.75}
              x2={width / 2}
              y2={height * 0.9}
              stroke={color}
              strokeWidth="2"
            />
          </>
        )}

        {type === 'bearish' && (
          <>
            {/* Upper wick */}
            <Line
              x1={width / 2}
              y1={height * 0.1}
              x2={width / 2}
              y2={height * 0.25}
              stroke={color}
              strokeWidth="2"
            />
            {/* Body */}
            <Rect
              x={width * 0.25}
              y={height * 0.25}
              width={width * 0.5}
              height={height * 0.5}
              fill={color}
              rx="2"
            />
            {/* Lower wick */}
            <Line
              x1={width / 2}
              y1={height * 0.75}
              x2={width / 2}
              y2={height * 0.9}
              stroke={color}
              strokeWidth="2"
            />
          </>
        )}

        {type === 'doji' && (
          <>
            {/* Upper wick */}
            <Line
              x1={width / 2}
              y1={height * 0.1}
              x2={width / 2}
              y2={height * 0.45}
              stroke={color}
              strokeWidth="2"
            />
            {/* Small body (Doji) */}
            <Rect
              x={width * 0.35}
              y={height * 0.45}
              width={width * 0.3}
              height={height * 0.1}
              fill={color}
              rx="1"
            />
            {/* Lower wick */}
            <Line
              x1={width / 2}
              y1={height * 0.55}
              x2={width / 2}
              y2={height * 0.9}
              stroke={color}
              strokeWidth="2"
            />
          </>
        )}
      </Svg>
    </View>
  );
};

export const CandlestickRow: React.FC<{ count?: number }> = ({ count = 5 }) => {
  const types: ('bullish' | 'bearish' | 'doji')[] = ['bullish', 'bearish', 'bullish', 'doji', 'bullish'];
  
  return (
    <View style={styles.row}>
      {types.slice(0, count).map((type, index) => (
        <CandlestickPattern key={index} type={type} size={40} />
      ))}
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    justifyContent: 'center',
    alignItems: 'center',
  },
  row: {
    flexDirection: 'row',
    justifyContent: 'space-around',
    alignItems: 'flex-end',
    paddingHorizontal: 10,
  },
});
